label: {
  device = "/dev/disk/by-partlabel/disk-emmc-${label}";
  fsType = "f2fs";
  options = [
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
  neededForBoot = true;
}
