{ inputs, lib, ... }:
{
  imports = [ (inputs.den.namespace "hosts" false) ];

  hosts.lib = {
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
        isPercent ? false,
        percent ? "25",
        fixed ? "4G",
      }:
      {
        nixos =
          { pkgs, ... }:
          {
            boot.initrd.systemd.services.zram-format = {
              wantedBy = [ "initrd.target" ];
              requiredBy = [ "sysroot.mount" ];
              before = [
                "initrd-fs.target"
                "sysroot.mount"
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
                ${lib.optionalString isPercent ''
                  TOTAL_MEM=$(grep MemTotal /proc/meminfo | ${pkgs.gawk}/bin/awk '{print $2 * 1024}')
                  SIZE=$((TOTAL_MEM * ${toString percent} / 100))
                ''}
                echo ${if isPercent then "$SIZE" else fixed} > /sys/block/zram1/disksize
                ${pkgs.e2fsprogs}/bin/mkfs.ext4 -m 0 -O "^has_journal,^huge_file,^flex_bg" /dev/zram1
              '';
            };
          };
      };
  };
}
