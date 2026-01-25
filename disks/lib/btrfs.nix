{
  name,
  size,
  label,
  mountpoint ? null,
  priority ? null,
  type ? null,
  postMountHook ? null,
  mountOptions ? [
    "compress-force=zstd:3"
    "commit=80"
  ],
  subvolumes ? null,
}:
{
  inherit
    name
    size
    type
    priority
    ;
  content = {
    inherit mountpoint postMountHook subvolumes;
    type = "btrfs";
    extraArgs = [
      "-f"
      "-L"
      "${label}"
    ];
    mountOptions = mountOptions ++ [
      "lazytime"
      "noatime"
      "discard=async"
      "space_cache=v2"
    ];
  };
}
