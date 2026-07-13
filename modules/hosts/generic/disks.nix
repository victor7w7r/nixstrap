{ disko, ... }:
{
  den.aspects.generic.disks.nixos.disko.devices = with disko; {
    bcachefs_filesystems.broot = bcachefs.filesystem {
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
        device = "vda";
        partitions = {
          system = bcachefs.partition {
            name = "system";
            size = "110G";
            priority = 7;
          };
        };
      };
    };
  };
}
