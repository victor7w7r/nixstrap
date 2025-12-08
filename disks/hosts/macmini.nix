let
  common = import ./common.nix;
in
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = common.ESP { };
            macos = {
              size = "110G";
              content = {
                type = "filesystem";
                format = "apfs";
              };
            };
            win = {
              size = "80G";
              content = {
                type = "filesystem";
                format = "ntfs";
              };
            };
            SYSTEM = common.CRYPT { };
          };
        };
      };
      storage = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            STORAGE = common.CRYPT { vg = "vg1"; };
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
              mkdir -p /mnt/nix /mnt/etc /mnt/root /mnt/opt /mnt/kvm
              mkdir -p /mnt/media/nvmestorage /mnt/media/docs
            '';
          };
          system = common.extpart {
            size = "60G";
            mountpoint = "/.nix";
            postMountHook = ''
              mkdir -p /mnt/.nix/etc /mnt/.nix/opt /mnt/.nix/nix /mnt/.nix/root
              mount --bind /mnt/.nix/root /mnt/root
              mount --bind /mnt/.nix/etc /mnt/etc
              mount --bind /mnt/.nix/opt /mnt/opt
              mount --bind /mnt/.nix/nix /mnt/nix
            '';
          };
          nvmestorage = common.btrfspart {
            size = "100%";
            mountpoint = "/media/nvmestorage";
            extraOptions = [ "compress-force=zstd:3" ];
          };
        };
      };
      vg1 = {
        type = "lvm_vg";
        lvs = {
          var = common.extpart {
            size = "5G";
            mountpoint = "/var";
          };
          home = common.extpart {
            size = "100%";
            mountpoint = "/home";
            postMountHook = "mkdir -p /home/common";
          };
        };
      };
    };
  };
}
