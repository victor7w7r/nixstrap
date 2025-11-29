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
              name = "EFI";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "relatime"
                  "fmask=0022"
                  "dmask=0022"
                  "umask=0077"
                  "codepage=437"
                  "iocharset=iso8859-1"
                  "shortname=mixed"
                  "utf8"
                  "errors=remount-ro"
                  ];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "SYSTEM";
                settings.allowDiscards = true;
                content = {
                  type = "lvm_pv";
                  vg = "vg0";
                };
              };
            };
          };
        };
      };
    };
    lvm_vg = {
      vg0 = {
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
              postMountHook = ''
                mkdir -p /mnt/kvm /mnt/usr /mnt/nix
                mkdir -p /mnt/etc /mnt/root /mnt/opt
              '';
            };
          };
          var = {
            size = "5G";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/var";
              extraArgs = commonArgs ++ [ "-L"  "var" ];
              mountOptions = commonOptions;
            };
          };
          home = {
            size = "10G";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/home";
              extraArgs = commonArgs ++ [ "-L"  "home" ];
              mountOptions = commonOptions;
              postMountHook = ''
                mkdir -p /home/.root /home/common
                mount --bind /home/.root /root
              '';
            };
          };
          system = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/nix";
              extraArgs = commonArgs ++ [ "-L"  "system" ];
              mountOptions = commonOptions;
              postMountHook = ''
                mkdir -p /mnt/nix/.etc /mnt/nix/.opt
                mount --bind /mnt/nix/.etc /mnt/etc
                mount --bind /mnt/nix/.opt /mnt/opt
                '';
            };
          };
        };
      };
    };
  };
}