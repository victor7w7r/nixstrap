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
          ESP = common.ESP { };
          SYSTEM = common.CRYPT { };
        };
      };
    };
    lvm_vg = {
      vg0 = {
        type = "lvm_vg";
        lvs = {
          fstemp = common.extpart {
            postMountHook = "mkdir -p /mnt/nix /mnt/etc /mnt/root /mnt/opt";
          };
          var = common.extpart {
            size = "5G";
            mountpoint = "/var";
          };
          home = common.extpart {
            size = "10G";
            mountpoint = "/home";
            postMountHook = "mkdir -p /home/common";
          };
          system = common.extpart {
            size = "100%";
            mountpoint = "/.nix";
            postMountHook = ''
              mkdir -p /mnt/.nix/etc /mnt/.nix/opt /mnt/.nix/nix /mnt/.nix/root
              mount --bind /mnt/.nix/root /mnt/root
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
