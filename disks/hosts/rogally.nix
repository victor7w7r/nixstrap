let
  common = import ./common.nix;
in
{
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          ESP = common.ESP { size = "400M"; };
          win = {
            size = "100G";
            content = {
              type = "filesystem";
              format = "ntfs";
              extraArgs = [
                "-f"
                "-Q"
              ];
            };
          };
          SYSTEM = common.CRYPT { size = "70G"; };
          games = common.btrfspart {
            size = "100%";
            mountpoint = "/games";
          };
        };
      };
    };
    lvm_vg = {
      vg0 = {
        type = "lvm_vg";
        lvs = {
          fstemp = common.extpart {
            postMountHook = ''
              mkdir -p /mnt/nix /mnt/etc /mnt/root /mnt/opt /mnt/games /mnt/home
            '';
          };
          var = common.extpart {
            size = "5G";
            mountpoint = "/var";
          };
          system = common.extpart {
            size = "100%";
            mountpoint = "/.nix";
            postMountHook = ''
              mkdir -p /mnt/.nix/etc /mnt/.nix/opt /mnt/.nix/nix /mnt/.nix/root /mnt/.nix/home
              mount --bind /mnt/.nix/root /mnt/root
              mount --bind /mnt/.nix/home /mnt/home
              mount --bind /mnt/.nix/etc /mnt/etc
              mount --bind /mnt/.nix/opt /mnt/opt
              mount --bind /mnt/.nix/nix /mnt/nix
            '';
          };
        };
      };
    };
  };
}
