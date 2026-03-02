{
  sharedDir ? "/run/media/shared",
  partlabel ? "shared",
  sharedDisk ? "main",
}:
{
  "${sharedDir}" = {
    device = "/dev/disk/by-partlabel/disk-${sharedDisk}-${partlabel}";
    fsType = "btrfs";
    options = [
      "lazytime"
      "noatime"
      "discard=async"
      "compress-force=zstd:2"
    ];
  };
}
