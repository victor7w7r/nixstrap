{ disko, ... }:
{
  den.aspects.pizero.disks.nixos.disko.devices = with disko; {
    disk = {
      root = ephemeral.root { };
      main = disk.gpt {
        device = "mmcblk0";
        partitions = {
          esp = esp.call { size = "500M"; };
          persist = f2fs.call {
            name = "persist";
            size = "100%";
            mountpoint = "/nix/persist";
            priority = 2;
          };
        };
      };
      sda = disk.gpt {
        device = "sda";
        partitions = {
          swapcrypt = luks.call {
            name = "swapcrypt";
            size = "4G";
            content = swap.call { };
            priority = 1;
          };
          system = xfs.call {
            name = "system";
            size = "100%";
            priority = 2;
          };
        };
      };
    };
  };
}
