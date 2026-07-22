{ disko, ... }:
{
  den.aspects.superlab.disks.nixos.disko = {
    fileSystems."/etc".neededForBoot = true;
    devices.disk = with disko; {
      root = ephemeral.root { };
      main = disk.gpt {
        device = "nvme0n1";
        partitions = {
          esp = esp.call { size = "256M"; };
          swapcrypt = luks.call {
            name = "swapcrypt";
            size = "32G";
            content = swap.call { };
            priority = 1;
          };
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
