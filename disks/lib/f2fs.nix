{
  label,
  mountpoint ? "/",
  name ? null,
  size ? null,
  priority ? null,
  lvmPool ? "",
  isIsolated ? false,
}:
let
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
    label
  ];
  part = {
    inherit name size;
    content = {
      type = "filesystem";
      format = "f2fs";
      inherit mountpoint mountOptions extraArgs;
    };
  };
in
if !isIsolated && lvmPool != "" then
  part
  // {
    lvm_type = "thinlv";
    pool = lvmPool;
  }
else if !isIsolated && priority != null then
  part
  // {
    inherit priority;
    type = "8300";
  }
else
  part
