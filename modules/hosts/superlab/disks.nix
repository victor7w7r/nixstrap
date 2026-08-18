{ disko, inputs, ... }:
{
  den.aspects.superlab.disks.nixos = {
    imports = [ inputs.disko.nixosModules.disko ];

    fileSystems = {
      "/nix/persist".neededForBoot = true;
      "/etc".neededForBoot = true;
    };
    disko.devices.disk = with disko; {
      root = disk.root { };
      main = disk.gpt {
        device = "nvme0n1";
        partitions = {
          esp = esp.call {
            size = "256M";
            name = "esp";
          };
          /*
            swapcrypt = luks.call {
            name = "swapcrypt";
            size = "32G";
            content = swap.call { };
            priority = 1;
            };
          */
          system = luks.call {
            name = "system";
            size = "100%";
            priority = 2;
            device = "${disk.constants.partlabel}/disk-main-system";
            content = btrfs.call {
              name = "system";
              isPartition = false;
              subvolumes = btrfs.subvolumes { hasEtc = true; };
            };
          };
        };
      };
    };
  };
}
