{
  name,
  size,
  label,
  mountpoint,
  postMountHook ? "",
  mountOptions ? [ "compress-force=zstd:3" ],
}:
{
  inherit name size;
  content = {
    type = "btrfs";
    extraArgs = [
      "-f"
      "L ${label}"
    ];
    inherit mountpoint postMountHook;
    mountOptions = mountOptions ++ [
      "lazytime"
      "noatime"
      "commit=80"
      "discard=async"
      "space_cache=v2"
    ];
  };
}
