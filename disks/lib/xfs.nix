{
  name,
  size,
  label,
  lvmPool ? "",
  mountpoint,
  postMountHook ? "",
  extraArgs ? [ ],
  mountOptions ? [ ],
}:
{
  inherit name size;
  content = {
    type = "filesystem";
    format = "xfs";
    inherit mountpoint postMountHook;
    mountOptions = mountOptions ++ [
      "attr2"
      "noatime"
      "lazytime"
      "nodiscard"
      "logbsize=256k"
      "inode64"
    ];
    extraArgs = extraArgs ++ [
      "-f"
      "-m"
      "crc=1,reflink=1"
      "-L"
      label
    ];
  };
}
// (
  if lvmPool != "" then
    {
      lvm_type = "thinlv";
      pool = lvmPool;
    }
  else
    { }
)
