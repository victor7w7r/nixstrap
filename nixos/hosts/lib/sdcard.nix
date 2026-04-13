{
  config,
  pkgs,
  firmwareSize ? 64,
  rootVolumeLabel ? "",
  populateFirmwareCommands ? "",
  populateRootCommands ? "",
  postBuildCommands ? "",
  preBuildCommands ? "",
  host,
}:
let
  imageName =
    "nixos-image-${config.system.nixos.label}-" + "${host}-${pkgs.stdenv.hostPlatform.system}";

  closureInfo = pkgs.buildPackages.closureInfo {
    rootPaths = [ config.system.build.toplevel ];
  };

  firmware = ''
    gap=8

    rootSizeBlocks=$(du -B 512 --apparent-size ./root.img | awk '{ print $1 }')
    firmwareSizeBlocks=$((${toString firmwareSize} * 1024 * 1024 / 512))
    imgSize=$((rootSizeBlocks * 512 + firmwareSizeBlocks * 512 + gap * 1024 * 1024))
    truncate -s $imgSize $img

    sfdisk --no-reread --no-tell-kernel $img <<EOF
      label: dos
      label-id: 0x2178694e
      start=''${gap}M, size=$firmwareSizeBlocks, type=b
      start=$((gap + ${toString firmwareSize}))M, type=83, bootable
    EOF

    eval $(partx $img -o START,SECTORS --nr 1 --pairs)
    truncate -s $((SECTORS * 512)) firmware_part.img
    mkfs.vfat --invariant -i 0x2178694e -n BOOT firmware_part.img
    mkdir firmware

    ${populateFirmwareCommands}

    find firmware -exec touch --date=2000-01-01 {} +
    cd firmware
    for d in $(find . -type d -mindepth 1 | sort); do
      faketime "2000-01-01 00:00:00" mmd -i ../firmware_part.img "::/$d"
    done
    for f in $(find . -type f | sort); do
      mcopy -pvm -i ../firmware_part.img "$f" "::/$f"
    done
    cd ..

    fsck.vfat -vn firmware_part.img
    dd conv=notrunc if=firmware_part.img of=$img seek=$START count=$SECTORS
  '';
in
{
  fileSystems = {
    "/" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [
        "relatime"
        "mode=755"
        "size=1G"
      ];
    };
    "/nix" = {
      device = "/dev/disk/by-label/${rootVolumeLabel}";
      fsType = "f2fs";
      options = [
        "lazytime"
        "noatime"
        "compress_chksum"
        "compress_algorithm=zstd:3"
        "age_extent_cache"
        "compress_extension=so"
        "inline_xattr"
        "inline_data"
        "inline_dentry"
        "errors=remount-ro"
        "compress_extension=bin"
        "atgc"
        "flush_merge"
        "discard"
        "checkpoint_merge"
        "gc_merge"
      ];
    };
    "/boot" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
      options = [
        "nofail"
        "noauto"
      ];
    };
  };

  system.nixos.tags = [ "sd-card" ];
  system.build.image = config.system.build.sdImage;
  system.build.sdImage =
    let
      nativePkgs = import pkgs.path {
        system = "x86_64-linux";
      };
    in
    nativePkgs.callPackage (
      {
        stdenv,
        libfaketime,
        fakeroot,
        util-linux,
        f2fs-tools,
        zstd,
      }:
      stdenv.mkDerivation {
        name = imageName;
        nativeBuildInputs = [
          nativePkgs.dosfstools
          nativePkgs.mtools
          libfaketime
          fakeroot
          util-linux
          f2fs-tools
          zstd
        ];

        buildCommand = ''
          mkdir -p $out/nix-support $out/sd-image
          export img=$out/sd-image/${imageName}.img

          echo "${pkgs.stdenv.buildPlatform.system}" > $out/nix-support/system
          (
            mkdir -p ./files
            ${populateRootCommands}
          )

          mkdir -p ./rootImage/nix/store
          xargs -I % cp -a --reflink=auto % -t ./rootImage/nix/store/ < ${closureInfo}/store-paths
          (
            GLOBIGNORE=".:.."
            shopt -u dotglob

            for f in ./files/*; do
                cp -a --reflink=auto -t ./rootImage/ "$f"
            done
          )

          cp ${closureInfo}/registration ./rootImage/nix-path-registration

          numInodes=$(find ./rootImage | wc -l)
          numDataBlocks=$(du -s -c -B 4096 --apparent-size ./rootImage | tail -1 | awk '{ print int($1 * 1.20) }')
          bytes=$((2 * 4096 * $numInodes + 4096 * $numDataBlocks))
          bytes=$((bytes + 100 * 1024 * 1024))
          bytes=$((bytes * 15 / 10))
          bytes=$(( ((bytes + 2097151) / 2097152) * 2097152 ))

          truncate -s $bytes ./root.img

          faketime -f "1970-01-01 00:00:01" fakeroot mkfs.f2fs -f -l "${rootVolumeLabel}" \
            -O extra_attr,compression,flexible_inline_xattr -q ./root.img

          faketime -f "1970-01-01 00:00:01" fakeroot sload.f2fs -f ./rootImage ./root.img || {
            echo "Error"
          }

          fakeroot fsck.f2fs -f ./root.img ||true

          ${preBuildCommands}
          ${firmware}

          eval $(partx $img -o START,SECTORS --nr 2 --pairs)
          dd conv=notrunc if=./root.img of=$img seek=$START count=$SECTORS

          ${postBuildCommands}

          #zstd -T$NIX_BUILD_CORES --rm $img
        '';
      }
    ) { };

  boot.postBootCommands = ''
    REG_FILE="/nix/nix-path-registration"
    if [ -f "$REG_FILE" ]; then
      set -euo pipefail
      set -x

      rootPart=$(${pkgs.util-linux}/bin/findmnt -n -o SOURCE /nix)
      bootDevice=$(lsblk -npo PKNAME $rootPart)
      partNum=$(lsblk -npo MAJ:MIN $rootPart | ${pkgs.gawk}/bin/awk -F: '{print $2}')

      echo ",+," | sfdisk -N$partNum --no-reread $bootDevice
      ${pkgs.parted}/bin/partprobe
      ${pkgs.f2fs-tools}/bin/resize.f2fs $rootPart

      ${config.nix.package.out}/bin/nix-store --load-db < $REG_FILE
      touch /etc/NIXOS
      ${config.nix.package.out}/bin/nix-env -p /nix/var/nix/profiles/system --set /run/current-system

      rm -f $REG_FILE
    fi
  '';

}
