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
  isSolid ? true,
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
    mountOptions =
      mountOptions
      ++ [
        "lazytime"
        "noatime"
        "space_cache=v2"
      ]
      ++ (if isSolid then [ "discard=async" ] else [ "autodefrag" ]);
  };
}
