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
          esp = esp.call { };
          msr = win.msr { };
          emergency = btrfs.emergency { priority = 3; };
          recovery = win.recovery { };
          win = win.call { };
          swapcrypt = luks.call {
            name = "swapcrypt";
            size = "14G";
            content = swap.call { };
            priority = 6;
          };
          system = bcachefs.partition {
            name = "system";
            size = "110G";
            priority = 7;
          };
          games = btrfs.shared { name = "games"; };
        };
      };
    };
  };
}
