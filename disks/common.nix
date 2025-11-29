{
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