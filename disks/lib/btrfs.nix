{
  label,
  name ? null,
  size ? null,
  mountpoint ? null,
  priority ? null,
  lvmPool ? "",
  mountOptions ? [ ],
  postMountHook ? "",
  subvolumes ? { },
  isIsolated ? false,
}:
let
  content = {
    inherit
      mountpoint
      postMountHook
      subvolumes
      mountOptions
      ;
    type = "btrfs";
    extraArgs = [
      "-f"
      "-L"
      "${label}"
    ];
  };
  part = { inherit name size content; };
in
if !isIsolated && lvmPool != "" then
  part
  // {
    lvm_type = "thinlv";
    pool = lvmPool;
  }
else if !isIsolated && priority != null then
  part
  // {
    inherit priority;
    type = "8300";
  }
else
  content
