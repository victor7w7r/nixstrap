rec {
  #"echo -n "password" > /tmp/pass.key"
  extCommonOptions = [
    "noatime"
    "lazytime"
    "nobarrier"
    "nodiscard"
    "commit=120"
  ];

  extCommonArgs = [
    "-F"
    "-E"
    "nodiscard,lazy_itable_init=1,lazy_journal_init=1"
    "-O"
    "64bit,dir_index,dir_nlink,ext_attr,extra_isize,extents,flex_bg,has_journal,meta_bg,sparse_super,\sparse_super2,uninit_bg,^resize_inode"
  ];

  ESP =
    {
      size ? "500M",
    }:
    {
      size = size;
      type = "EF00";
      name = "EFI";
      content = {
        type = "filesystem";
        format = "vfat";
        mountpoint = "/boot";
        extraArgs = [
          "-n"
          "EFI"
        ];
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

  CRYPT =
    {
      size ? "100%",
      vg ? "vg0",
    }:
    {
      size = size;
      content = {
        type = "luks";
        name = "cryptsystem";
        settings = {
          keyFile = "/tmp/pass.key";
          allowDiscards = true;
        };
        content = {
          type = "lvm_pv";
          vg = vg;
        };
        preCreateHook = ''
          dd if=/dev/urandom of=/root/nixstrap/syskey.key bs=1 count=64
          chmod 0400 /root/nixstrap/syskey.key
          git config --global user.email "nixos@flake.com" && \
          git config --global user.name "nixosflake" && \
          git config --global --add safe.directory /root/nixstrap && \
          cd /root/nixstrap && git add . && git commit -m "Add Key"
        '';
        postCreateHook = ''
          cryptsetup config /dev/disk/by-partlabel/disk-main-SYSTEM --label "SYSTEM"
          cryptsetup luksAddKey /dev/disk/by-partlabel/disk-main-SYSTEM /root/nixstrap/syskey.key -d /tmp/pass.key
        '';
      };
    };

  extpart =
    {
      size ? "400M",
      mountpoint ? "/",
      postMountHook ? "",
    }:
    {
      size = size;
      content = {
        type = "filesystem";
        format = "ext4";
        mountpoint = mountpoint;
        extraArgs = extCommonArgs ++ [
          "-L"
          "fstemp"
        ];
        mountOptions = extCommonOptions;
        postMountHook = postMountHook;
      };
    };

  btrfspart =
    {
      size,
      mountpoint,
      extraOptions ? [
        "compress-force=zstd:7"
      ],
    }:
    {
      size = size;
      content = {
        type = "btrfs";
        extraArgs = [ "-f" ];
        mountpoint = mountpoint;
        mountOptions = [
          "lazytime"
          "nodiscard"
          "commit=60"
          "noatime"
        ]
        ++ extraOptions;
      };
    };
}
