{ disko, lib, ... }:
{
  disko.f2fs = {
    call =
      {
        name ? "",
        priority ? 0,
        mountpoint,
        entireDisk ? false,
        hasDefSectorSize ? false,
        size ? null,
      }:
      (disko.f2fs.args name hasDefSectorSize)
      |> (args: {
        inherit mountpoint;
        type = "filesystem";
        format = "f2fs";
        mountOptions = args.mountOptions;
        extraArgs = args.extraArgs;
      })
      |> (
        content:
        if (!entireDisk) then
          {
            inherit
              name
              size
              priority
              content
              ;
            type = "8300";
          }
        else
          content
      );

    args = name: hasDefSectorSize: {
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
      ]
      ++ (lib.optionals hasDefSectorSize [
        "-S"
        "4096"
      ]);
    };
  };
}
