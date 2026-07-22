{ inputs, sdcard, ... }:
{
  imports = [ (inputs.den.namespace "sdcard" false) ];

  sdcard.lib.call =
    {
      bootSize ? 96,
      isHDD ? true,
      nextPartSize ? 1024,
      isExtlinux ? true,
      useGpt ? false,
      isEntireDisk ? false,
      ubootSelector ? "",
      nextPartName ? "root",
      persistLabel ? "persist",
      postBuildCommands ? "",
      storeLabel ? "store",
    }:
    {
      includes = [ (sdcard.lib.postscript isHDD) ];

      nixos =
        {
          config,
          host,
          lib,
          pkgs,
          ...
        }:
        {
          system.nixos.tags = [ "sd-card" ];
          system.build.image = config.system.build.sdImage;
          system.build.bootFiles = (sdcard.lib.kernel pkgs ubootSelector postBuildCommands true);
          system.build.sdImage = pkgs.stdenv.mkDerivation {
            name = "nixos-image-${config.system.nixos.label}-" + "${host}-${pkgs.stdenv.hostPlatform.system}";
            nativeBuildInputs = with pkgs; [
              btrfs-progs
              dosfstools
              fakeroot
              f2fs-tools
              libfaketime
              mtools
              util-linux
              xfsprogs
              zstd
            ];

            buildCommand =
              with sdcard.lib;
              (pkgs.buildPackages.closureInfo { rootPaths = [ config.system.build.toplevel ]; })
              |> (closureInfo: ''
                mkdir -p $out
                ${lib.optionalString (!isEntireDisk) (persist nextPartSize persistLabel)}
                ${
                  (image bootSize nextPartSize useGpt nextPartName (
                    lib.optionalString isExtlinux ''
                      mkdir -p firmware/boot
                      ${config.boot.loader.generic-extlinux-compatible.populateCmd} \
                        -c ${config.system.build.toplevel} -d firmware/boot
                    ''
                  ))
                }
                ${lib.optionalString (
                  !isEntireDisk
                ) "dd conv=notrunc if=./persist.img of=boot.img seek=$START count=$SECTORS"}
                echo "Copying uboot and compressing kernel image..."

                ${(kernel pkgs ubootSelector postBuildCommands false)}
                ${(store closureInfo isHDD storeLabel)}
              '');
          };
        };
    };
}
