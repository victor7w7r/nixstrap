{
  name,
  size,
  label,
  mountpoint,
  postMountHook ? "",
  extraArgs ? [ ],
  mountOptions ? [ ],
}:
{
  inherit name size;
  content = {
    type = "filesystem";
    format = "ext4";
    inherit mountpoint postMountHook;
    mountOptions = mountOptions ++ [
      "noatime"
      "lazytime"
      "nobarrier"
      "nodiscard"
      "commit=120"
    ];
    extraArgs = extraArgs ++ [
      "-F"
      "-E"
      "nodiscard,lazy_itable_init=1,lazy_journal_init=1"
      "-O"
      "64bit,dir_index,dir_nlink,ext_attr,extra_isize,extents,flex_bg,has_journal,meta_bg,sparse_super,\sparse_super2,uninit_bg,^resize_inode"
      "-L"
      label
    ];
  };
}
