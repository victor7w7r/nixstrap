{
  name,
  size,
  label,
  mountpoint ? null,
  type ? null,
  priority ? null,
  lvmPool ? "",
  postMountHook ? "",
  subvolumes ? { },
  isSolid ? true,
}:
{
  inherit name size;
  content = {
    inherit mountpoint postMountHook subvolumes;
    type = "btrfs";
    extraArgs = [
      "-f"
      "-L"
      "${label}"
    ];
    mountOptions = [
      "lazytime"
      "noatime"
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
