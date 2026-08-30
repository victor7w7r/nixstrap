{
  den.default.nixos =
    { pkgs, ... }:
    {
      boot.initrd = {
        checkJournalingFS = true;
        services.lvm.enable = true;
        compressorArgs = [
          "-19"
          "--ultra"
          "-T0"
          "--check"
        ];
        network.enable = true;
        verbose = true;
        systemd = {
          enable = true;
          emergencyAccess = true;
          users.root.shell = "${pkgs.bashInteractive}/bin/bash";
          contents = {
            "/etc/ssl/certs/ca-certificates.crt".source = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
            #"/etc/terminfo".source = "${pkgs.ncurses}/share/terminfo";
          };
          settings.Manager = {
            DefaultTimeoutStartSec = "15s";
            DefaultTimeoutStopSec = "10s";
            DefaultTimeoutAbortSec = "5s";
            DefaultLimitNOFILE = "2048:2097152";
          };
          initrdBin = with pkgs; [ coreutils ];
          storePaths = with pkgs; [
            "${bashInteractive}/bin/bash"
            util-linux
            "${util-linux}/bin/mount"
            "${util-linux}/bin/umount"
            "${coreutils}/bin/sleep"
            "${systemd}/bin/udevadm"
          ];
          extraBin = with pkgs; {
            nix = "${nix}/bin/nix";
            ip = "${iproute2}/bin/ip";
            curl = "${curl}/bin/curl";
            clear = "${ncurses}/bin/clear";
            ping = "${iputils}/bin/ping";
            cryptsetup = "${cryptsetup}/bin/cryptsetup";
            efibootmgr = "${pkgs.efibootmgr}/bin/efibootmgr";
            busybox = "${busybox-sandbox-shell}/bin/busybox";
            htop = "${htop}/bin/htop";
            yazi = "${yazi-unwrapped}/bin/yazi";
            find = "${findutils}/bin/find";
            fdisk = "${util-linux}/bin/fdisk";
            lshw = "${pkgs.lshw}/bin/lshw";
            file = "${file}/bin/file";
            blkid = "${util-linux}/bin/blkid";
            lsblk = "${util-linux}/bin/lsblk";
            lspci = "${pciutils}/bin/lspci";
            grep = "${gnugrep}/bin/grep";
          };

          services.emergency-overlay = {
            wantedBy = [ "initrd.target" ];
            before = [ "initrd-root-fs.target" ];
            after = [ "dev-zram1.device" ];
            unitConfig.DefaultDependencies = false;

            script = ''
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
                  -o lowerdir=/mnt/erofs-raw,upperdir=/mnt/overlay-rw/upper,workdir=/mnt/overlay-rw/work \
                  /sysroot
              fi
            '';
          };
        };
      };
    };
}
