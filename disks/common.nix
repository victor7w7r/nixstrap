{
  #"echo -n "password" > /tmp/pass.key"
  ESP = {
    size = "500M";
    type = "EF00";
    name = "EFI";
    content = {
      type = "filesystem";
      label = "EFI";
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

  SYSTEM = {
    size = "100%";
    content = {
      type = "luks";
      name = "cryptsystem";
      settings = {
        keyFile = "/tmp/pass.key";
        allowDiscards = true;
      };
      content = {
        type = "lvm_pv";
        vg = "vg0";
      };
      preCreateHook = ''
        dd if=/dev/urandom of=/tmp/keygen.key bs=1 count=64
        chmod 0400 /tmp/keygen.key
      '';
      postCreateHook = ''
        cryptsetup config /dev/disk/by-partlabel/disk-main-SYSTEM --label "SYSTEM"
        cryptsetup luksAddKey /dev/disk/by-partlabel/disk-main-SYSTEM /tmp/keygen.key -d /tmp/pass.key
      '';
    };
  };

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
}
