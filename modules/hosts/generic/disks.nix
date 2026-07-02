{ disko, ... }:
{
  den.aspects.generic.nixos = {
    fileSystems."/" = {
      device = "/dev/zram1";
      fsType = "ext4";
      neededForBoot = true;
      options = [
        "noatime"
        "x-systemd.device-timeout=0"
      ];
    };

    /*
      params = import ./lib/kernel-params.nix;
      boot = import ./lib/boot.nix { };
      btrfs = (import ./lib/btrfs.nix);

      fileSystems = {
        inherit (boot) "/boot" "/boot/emergency";
        "/" = btrfs { };
        "/nix" = btrfs { subvol = "nix"; };
        "/nix/persist" = btrfs {
          subvol = "persist";
          depends = [ "/nix" ];
        };
      };
    */
    disko.devices = {
      disk.main = {
        type = "disk";
        device = "/dev/vda";
        content = {
          type = "gpt";
          partitions = {
            esp = disko.esp.call { };
            emergency = disko.btrfs.emergency { isSolid = false; };
            system = disko.bcachefs.partition {
              name = "system";
              size = "90G";
            };
          };
        };
      };
      bcachefs_filesystems = {
        broot = disko.bcachefs.filesystem {
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
