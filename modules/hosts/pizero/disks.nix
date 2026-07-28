{ disko, ... }:
{
  den.aspects.pizero.disks.nixos = {
    fileSystems."/nix/persist".neededForBoot = true;
    disko.devices = with disko; {
      disk = {
        root = disk.root { };
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
            swapcrypt = {
              size = "4G";
              content = {
                type = "swap";
                discardPolicy = "both";
                resumeDevice = true;
                priority = 100;
              };
            };
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
