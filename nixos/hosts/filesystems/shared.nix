{ sharedDir ? "/shared", partlabel ? "shared" }:
{
  sharedDir = {
    device = "/dev/disk/by-partlabel/disk-main-${partlabel}";
    fsType = "btrfs";
    options = [
      "lazytime"
      "noatime"
      "discard=async"
      "space_cache=v2"
      "compress-force=zstd:2"
    ];
  };
}
