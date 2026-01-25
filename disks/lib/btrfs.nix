{
  name,
  size,
  label,
  mountpoint ? null,
  type ? null,
  priority ? null,
  lvmPool ? "",
  postMountHook ? "",
  mountOptions ? [
    "compress-force=zstd:3"
    "commit=80"
  ],
  subvolumes ? { },
  isSolid ? true,
}:
{
  inherit
    name
    size
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
// (
  if lvmPool != "" then
    {
      lvm_type = "thinlv";
      pool = lvmPool;
    }
  else
    {
      inherit priority type;
    }
)
