let
  commonOptions = [
    "noatime"
    "lazytime"
    "nobarrier"
    "nodiscard"
    "commit=120"
  ];
  commonArgs = [
    "-F"
    "-E"
    "nodiscard,lazy_itable_init=1,lazy_journal_init=1"
    "-O"
    "64bit,dir_index,dir_nlink,ext_attr,extra_isize,extents,flex_bg,has_journal,meta_bg,sparse_super,\sparse_super2,uninit_bg,^resize_inode"
  ];
in
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/vda";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "500M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "SYSTEM";
                settings = {
                  keyFile = "/tmp/secret.key";
                  allowDiscards = true;
                };
                content = {
                  type = "lvm_pv";
                  vg = "pool";
                };
              };
            };
          };
        };
      };
    };
    lvm_vg = {
      pool = {
        type = "lvm_vg";
        lvs = {
          fstemp = {
            size = "1G";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              extraArgs = commonArgs ++ [ "-L"  "fstemp" ];
              mountOptions = commonOptions;
              postCreateHook = ''
                mkdir -p /mnt/media/vm \
                /mnt/usr /mnt/etc /mnt/root /mnt/var /mnt/home /mnt/opt /mnt/.rootfs \
                /mnt/.varfs /mnt/nix /mnt/boot /mnt/media/ext/.fs
              '';
            };
          };
          var = {
            size = "5G";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/.varfs";
              extraArgs = commonArgs ++ [ "-L"  "var" ];
              mountOptions = commonOptions;
              postCreateHook = ''
                mkdir -p /mnt/.varfs/root && \
                mkdir -p /mnt/.varfs/var
              '';
            };
          };
          home = {
            size = "10G";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/mnt/media/ext";
              extraArgs = commonArgs ++ [ "-L"  "home" ];
              mountOptions = commonOptions;
              postCreateHook = ''
                mkdir -p /mnt/media/ext/.fs/home && \
                mkdir -p /mnt/media/ext/.fs/opt
              '';
            };
          };
          root = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/.rootfs";
              extraArgs = commonArgs ++ [ "-L"  "system" ];
              mountOptions = commonOptions;
              postCreateHook = ''
                mkdir -p /mnt/.rootfs/etc && \
                mkdir -p /mnt/.rootfs/nix
                mount --bind /mnt/.rootfs/etc /mnt/etc && \
                mount --bind /mnt/.rootfs/usr /mnt/usr && \
                mount --bind /mnt/.rootfs/nix /mnt/nix && \
                mount --bind /mnt/.varfs/root /mnt/root && \
                mount --bind /mnt/.varfs/var /mnt/var && \
                mount --bind /mnt/media/ext/.fs/home /mnt/home && \
                mount --bind /mnt/media/ext/.fs/opt /mnt/opt
              '';
            };
          };
        };
      };
    };
  };
}