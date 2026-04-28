{
  partition =
    {
      name,
      size,
      priority ? 5,
      filesystem ? "broot",
      extraOptions ? []
    }:
    {
      inherit priority size name;
      type = "8300";
      content = {
        inherit filesystem;
        type = "bcachefs";
        label = name;
        extraFormatArgs = [
          "-f"
          "-L"
          name
          "--discard"
        ] ++ extraOptions;
      };
    };

  filesystem =
    {
      passwordFile ? null,
      mountpoint ? null,
      uuid ? null,
      extraOptions ? [ ],
      extraFormatArgs ? [ ],
      subvolumes ? {
       "subvolumes/root" = {
         mountpoint = "/";
         mountOptions = [
           "lazytime"
           "noatime"
           "discard"
           "fsck"
         ] ++ extraOptions;
       };
       "subvolumes/nix" = {
         mountpoint = "/nix";
         mountOptions = [
           "lazytime"
           "noatime"
           "discard"
           "fsck"
         ] ++ extraOptions;
       };
       "subvolumes/persist" = {
         mountpoint = "/nix/persist";
         mountOptions = [
           "lazytime"
           "noatime"
           "discard"
           "fsck"
         ] ++ extraOptions;
       };
      }
    }:
    {
      inherit passwordFile mountpoint subvolumes uuid;
      type = "bcachefs_filesystem";
      extraFormatArgs = [
        "--compression=lz4"
        "--background_compression=lz4"
        "--metadata_checksum=xxhash"
        "--data_checksum=xxhash"
      ] ++ extraFormatArgs;
    };
}
