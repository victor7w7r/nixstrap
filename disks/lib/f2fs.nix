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
