{
  label,
  name ? null,
  size ? null,
  mountpoint ? null,
  priority ? null,
  lvmPool ? "",
  postMountHook ? "",
  enableCompress ? false,
  subvolumes ? { },
  isIsolated ? false,
  isSolid ? true,
}:
let
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
      (if isSolid then "discard=async" else "autodefrag")
      (if enableCompress then "compress=zstd" else "")
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
