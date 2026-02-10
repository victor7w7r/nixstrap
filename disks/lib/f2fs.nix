{
  name,
  size ? null,
  mountpoint ? "/",
  priority ? null,
}:
{
  inherit name size;
  content = {
    type = "filesystem";
    format = "f2fs";
    inherit mountpoint;
    mountOptions = [
      "lazytime"
      "noatime"
      "compress_chksum"
      "compress_algorithm=zstd:3"
      "age_extent_cache"
      "compress_extension=so"
      "inline_xattr"
      "inline_data"
      "inline_dentry"
      "errors=remount-ro"
      "compress_extension=bin"
      "atgc"
      "flush_merge"
      "discard"
      "checkpoint_merge"
      "gc_merge"
    ];
    extraArgs = [
      "-f"
      "-O"
      "extra_attr,inode_checksum,compression,flexible_inline_xattr,lost_found,sb_checksum"
      "-l"
      name
    ];
  };
}
// (
  if priority != null then
    {
      inherit priority;
      type = "8300";
    }
  else
    { }
)
