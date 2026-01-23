{
  name,
  size,
  label,
  mountpoint ? null,
  postMountHook ? "",
  mountOptions ? [
    "compress-force=zstd:3"
    "commit=80"
  ],
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
      "discard=async"
      "space_cache=v2"
    ];
  };
}
