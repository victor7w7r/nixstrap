{ disko, ... }:
{
  den.aspects.handheld.disks.nixos =
    let
      partitions = {
        esp = disko.esp.call { };
        msr = disko.win.msr { };
        emergency = disko.btrfs.emergency { priority = 3; };
        recovery = disko.win.recovery { };
        win = disko.win.call { };
        swapcrypt = disko.luks.call {
          name = "swapcrypt";
          size = "14G";
          content = disko.swap.call { };
          priority = 6;
        };
        system = disko.bcachefs.partition {
          name = "system";
          size = "110G";
          priority = 7;
        };
        games = disko.btrfs.shared {
          name = "games";
          mountContent = "games";
          mountSnap = "gamessnap";
        };
      };
    in
    {
      disko.devices = {
        disk.root = {
          type = "disk";
          device = "/dev/zram1";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
            mountOptions = [
              "noatime"
              "x-systemd.device-timeout=0"
            ];
          };
        };

        disk.main = {
          type = "disk";
          device = "/dev/nvme0n1";
          content = {
            type = "gpt";
            inherit partitions;
          };
        };
        bcachefs_filesystems = {
          broot = disko.bcachefs.filesystem {
            uuid = "2564fcf6-551f-4358-b238-2fe638b1c159";
            subvolumes = {
              "subvolumes/nix" = {
                mountpoint = "/nix";
                mountOptions = [
                  "nodiratime"
                  "noatime"
                  "discard"
                ];
              };
              "subvolumes/persist" = {
                mountpoint = "/nix/persist";
                mountOptions = [
                  "nodiratime"
                  "noatime"
                  "discard"
                ];
              };
            };
          };
        };
      };
    };
}
