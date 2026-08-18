{
  den.aspects.emergency.nixos =
    { config, pkgs, ... }:
    {
      system.build.emergency-erofs = pkgs.stdenvNoCC.mkDerivation {
        name = "emergency-erofs";

        nativeBuildInputs = with pkgs; [ erofs-utils ];

        buildCommand =
          (pkgs.buildPackages.closureInfo { rootPaths = [ config.system.build.toplevel ]; })
          |> (closureInfo: ''
            mkdir -p rootfs/nix/store

            for path in $(cat ${closureInfo}/store-paths); do
              cp -a "$path" "rootfs/nix/store/"
            done

            mkdir -p rootfs/etc rootfs/var rootfs/proc rootfs/sys rootfs/dev rootfs/tmp rootfs/run
            ln -s ${config.system.build.toplevel}/init rootfs/init

            mkfs.erofs -z zstd emergency.erofs rootfs/
            cp emergency.erofs $out
          '');
      };

      boot.initrd.postDeviceCommands = ''
        if grep -q "emergency-mode-on" /proc/cmdline; then
          mkdir -p /mnt/erofs-raw /mnt/overlay-rw /sysroot

          mount -o loop /emergency.erofs /mnt/erofs-raw

          TOTAL_MEM=$(grep MemTotal /proc/meminfo | ${pkgs.gawk}/bin/awk '{print $2 * 1024}')
          SIZE=$((TOTAL_MEM * 50 / 100))
          echo "$SIZE" > /sys/block/zram1/disksize
          ${pkgs.e2fsprogs}/bin/mkfs.ext4 -m 0 -O "^has_journal,^huge_file,^flex_bg" /dev/zram1

          mount -t ext4 -o discard,noatime /dev/zram1 /mnt/overlay-rw
          mkdir -p /mnt/overlay-rw/upper /mnt/overlay-rw/work

          mount -t overlay overlay \
            -o lowerdir=/mnt/erofs-raw,upperdir=/mnt/overlay-rw/upper,workdir=/overlay-rw/work \
            "$targetRoot"

          export rootMounted=1
        fi
      '';
    };
}
