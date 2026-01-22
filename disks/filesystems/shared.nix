{
  size ? "100%",
  name ? "Shared",
  mountpoint ? "/media/shared",
  priority ? 100,
}:
{
  inherit name size priority;
  type = "8300";
  content = {
    type = "btrfs";
    extraArgs = [ "-f" ];
    inherit mountpoint;
    mountOptions = [
      "lazytime"
      "noatime"
      "commit=60"
      "discard=async"
      "space_cache=v2"
      "compress-force=zstd:6"
    ];
  };
}
