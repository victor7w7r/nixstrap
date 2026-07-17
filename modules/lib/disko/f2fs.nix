{ disko, ... }:
{
  disko.f2fs = {
    call =
      {
        name,
        priority,
        mountpoint,
        size ? null,
      }:
      (disko.f2fs.args name)
      |> (args: {
        inherit name size priority;
        type = "8300";
        content = {
          inherit mountpoint;
          type = "filesystem";
          format = "f2fs";
          mountOptions = args.mountOptions;
          extraArgs = args.extraArgs;
        };
      });

    args = name: {
      mountOptions = [
        "lazytime"
        "noatime"
        "compress_chksum"
        "compress_algorithm=zstd"
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
  };
}
