{
  name,
  size,
  label,
  mountpoint,
  lvm_type ? null,
  pool ? null,
  postMountHook ? "",
  extraArgs ? [ ],
  mountOptions ? [ ],
}:
{
  inherit
    name
    size
    lvm_type
    pool
    ;
  content = {
    type = "filesystem";
    format = "f2fs";
    inherit mountpoint postMountHook;
    mountOptions = mountOptions ++ [ ];
    extraArgs = extraArgs ++ [
      "-f"
      "-O"
      "extra_attr"
      "inode_checksum"
      "flexible_inline_xattr"
      "sb_checksum"
      "-l"
      label
    ];
  };
}
