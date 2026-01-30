{
  name,
  size,
  label,
  mountpoint ? null,
  priority ? null,
  lvmPool ? "",
  postMountHook ? "",
  enableCompress ? false,
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
      enableCompress
      "noatime"
    ]
    ++ (if isSolid then [ "discard=async" ] else [ "autodefrag" ])
    ++ (if enableCompress then [ "compress=zstd" ] else [ ]);
  };
}
// (
  if lvmPool != "" then
    {
      lvm_type = "thinlv";
      pool = lvmPool;
    }
  else if priority != null then
    {
      inherit priority;
      type = 8300;
    }
  else
    { }
)
