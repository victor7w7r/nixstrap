{
  partition =
    {
      name,
      size,
      priority ? 5,
      filesystem ? "broot"
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
      extraOptions ? [ ],
      subvolumes ? {
       "subvolumes/root" = {
         mountpoint = "/";
         mountOptions = extraOptions;
       };
       "subvolumes/nix" = {
         mountpoint = "/nix";
         mountOptions = extraOptions;
       };
       "subvolumes/persist" = {
         mountpoint = "/nix/persist";
         mountOptions = extraOptions;
       };
    }:
    {
      inherit passwordFile mountpoint subvolumes;
      type = "bcachefs_filesystem";
      extraFormatArgs = [
        "--compression=lz4"
        "--background_compression=lz4"
      ] ++ extraFormatArgs;
    };
}
