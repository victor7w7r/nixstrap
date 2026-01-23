{
  name,
  size,
  label,
  mountpoint ? null,
  postMountHook ? "",
  mountOptions ? [ "compress-force=zstd:3" ],
  subvolumes ? null,
}:
{
  inherit name size;
  content = {
    type = "btrfs";
    extraArgs = [
      "-f"
      "-L ${label}"
    ];
    inherit mountpoint postMountHook subvolumes;
    mountOptions = mountOptions ++ [
      "lazytime"
      "noatime"
      "commit=80"
      "discard=async"
      "space_cache=v2"
    ];
  };
}
