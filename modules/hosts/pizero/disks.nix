{ disko, inputs, ... }:
{
  den.aspects.pizero.disks.nixos = with disko; {
    imports = [ inputs.disko.nixosModules.disko ];
    fileSystems = {
      "/etc".neededForBoot = true;
      "/nix/persist" = {
        device = "/dev/mapper/system";
        fsType = "f2fs";
        depends = [ "/nix" ];
        neededForBoot = true;
        options = (f2fs.args "system" false).mountOptions;
      };
    };
    disko.devices = {
      disk = {
        root = disk.root { };
        main = disk.gpt {
          device = "mmcblk0";
          partitions = {
            esp = esp.call {
              size = "256M";
              name = "esp";
            };
            /*
              system = f2fs.call {
                name = "system";
                size = "100%";
                mountpoint = "/nix/persist";
                priority = 2;
              };
            */
          };
        };
        sda = disk.gpt {
          device = "sda";
          partitions = {
            /*
              swapcrypt = luks.call {
               name = "swapcrypt";
               size = "4G";
               content = swap.call { };
               priority = 6;
               };
            */
            system = btrfs.call {
              name = "system";
              priority = 2;
              size = "100%";
              subvolumes = btrfs.subvolumes {
                hasEtc = true;
                hasPersist = false;
              };
            };
          };
        };
      };
    };
  };
}
