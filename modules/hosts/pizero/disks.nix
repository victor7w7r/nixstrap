{ disko, ... }:
{
  den.aspects.handheld.disks.nixos.disko.devices = with disko; {
    disk = {
      root = ephemeral.root { };
      main = disk.gpt {
        device = "mmcblk0";
        partitions = {
          esp = esp.call { size = "500M"; };
          system = f2fs.call {
            name = "system";
            size = "100%";
            priority = 2;
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
            store = xfs.call {
              name = "store";
              size = "100%";
              priority = 2;
            };
          };
        };
      };
    };
  };
}
