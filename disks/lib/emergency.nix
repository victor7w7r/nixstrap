{
  size ? "3G",
  name ? "Emergency",
  mountpoint ? "/boot/emergency",
  priority ? 2,
}:
{
  inherit name size priority;
  type = "8300";
  content = {
    type = "btrfs";
    extraArgs = [
      "-f"
      "-L emergency"
    ];
    inherit mountpoint;
    mountOptions = [
      "lazytime"
      "noatime"
      "commit=60"
      "discard=async"
      "space_cache=v2"
      "compress-force=zstd"
    ];
  };
}
