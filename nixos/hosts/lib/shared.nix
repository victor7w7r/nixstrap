{
  sharedDir ? "/run/media/shared",
  partlabel ? "shared",
}:
{
  "${sharedDir}" = {
    device = "/dev/disk/by-partlabel/disk-main-${partlabel}";
    fsType = "btrfs";
    options = [
      "lazytime"
      "noatime"
      "discard=async"
      "compress-force=zstd:2"
    ];
  };
}
