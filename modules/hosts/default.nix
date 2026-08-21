{
  _module.args.hosts.lib = {
    static-network = iface: address: {
      nixos.networking.networkmanager.ensureProfiles.profiles."static-network" = {
        connection = {
          id = "static-network";
          type = "ethernet";
          interface-name = iface;
          autoconnect = true;
        };
        ipv6.method = "disabled";
        ipv4 = {
          method = "manual";
          addresses = "192.168.100.${address}";
          gateway = "192.168.100.1";
          dns = "1.1.1.1;8.8.8.8;";
        };
      };
    };

    zram =
      {
        mappers ? [ ],
        value ? "4G",
        memoryPercent ? 50
      }:
      {
        nixos =
          { pkgs, ... }:
          {
            zramSwap = {
              enable = true;
              algorithm = "zstd";
              inherit memoryPercent;
              priority = 100;
            };
            boot.initrd.systemd.services.zram-rootfs = {
              wantedBy = [ "initrd.target" ];
              requiredBy = [
                "cryptsetup.target"
                "sysroot.mount"
              ];
              before = [
                "cryptsetup.target"
                "initrd-fs.target"
                "sysroot.mount"
                "systemd-cryptsetup-pre.target"
              ]
              ++ mappers;
              after = [ "systemd-modules-load.service" ];
              unitConfig.DefaultDependencies = false;
              serviceConfig = {
                Type = "oneshot";
                RemainAfterExit = true;
              };
              path = with pkgs; [
                coreutils
                e2fsprogs
                systemd
                util-linux
              ];
              script = ''
                set -e
                echo ${value} > /sys/block/zram1/disksize
                ${pkgs.e2fsprogs}/bin/mkfs.ext4 -m 0 -O "^has_journal,^huge_file,^flex_bg" /dev/zram1
              '';
            };
          };
      };
  };
}
