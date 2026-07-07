{ disko, ... }:
{
  den.aspects.handheld.disks.nixos.disko.devices = with disko; {
    bcachefs_filesystems.broot = bcachefs.filesystem {
      uuid = "2564fcf6-551f-4358-b238-2fe638b1c159";
      subvolumes =
        (bcachefs.subvolume {
          name = "nix";
          mountpoint = "/nix";
        })
        // (bcachefs.subvolume {
          name = "persist";
          mountpoint = "/nix/persist";
        });
    };
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
        nvme = disk.gpt {
          device = "nvme0n1";
          partitions = {
            swapcrypt = luks.call {
              name = "swapcrypt";
              size = "32G";
              content = swap.call { };
              priority = 1;
            };
            store = bcachefs.partition {
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
