{
  name,
  size,
  label,
  mountpoint ? null,
  priority ? null,
  type ? null,
  lvmPool ? "",
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
// (
  if lvmPool != "" then
    {
      lvm_type = "thinlv";
      pool = lvmPool;
    }
  else
    {
      inherit type;
    }
)
