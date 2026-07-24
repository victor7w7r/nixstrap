{ disko, lib, ... }:
{
  den.aspects.pizero.disks.nixos = {
    fileSystems."/nix/persist".neededForBoot = true;
    boot.initrd = lib.mkForce {
      systemd.settings = {
        Manager = {
          DefaultTimeoutStartSec = "30s";
          DefaultTimeoutStopSec = "30s";
        };
      };
      systemd.units."systemd-cryptsetup@*.service".text = ''
        [Job]
        JobTimeoutSec=30s
      '';
    };
    disko.devices = with disko; {
      disk = {
        root = ephemeral.root { };
        main = disk.gpt {
          device = "mmcblk0";
          partitions = {
            esp = esp.call {
              size = "256M";
              name = "esp";
            };
            system = f2fs.call {
              name = "system";
              size = "100%";
              mountpoint = "/nix/persist";
              priority = 2;
            };
          };
        };
        sda = disk.gpt {
          device = "sda";
          partitions = {
            /*
              swapcrypt = {
               size = "4G";
               content = {
                 type = "swap";
                 discardPolicy = "both";
                 resumeDevice = true;
                 priority = 100;
               };
               };
            */
            system = xfs.call {
              name = "system";
              size = "100%";
              mountpoint = "/nix";
            };
          };
        };
      };
    };
  };
}
