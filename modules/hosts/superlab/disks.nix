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
          system = btrfs.call {
            name = "system";
            size = "100%";
            priority = 2;
            subvolumes = disko.btrfs.subvolumes {
              hasEtc = true;
            };
          };
        };
      };
    };
  };
}
