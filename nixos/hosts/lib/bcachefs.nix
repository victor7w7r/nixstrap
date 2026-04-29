{
  depends ? [ ],
  device ? "/dev/disk/by-partlabel/disk-ssd-system",
  extraOptions ? [ ]
}:
{
  fsType = "bcachefs";
  options = [
    "lazytime"
    "noatime"
    "discard"
    "compression=lz4"
    "background_compression=zstd"
    "X-mount.mkdir"
  ] ++ extraOptions;

  inherit device depends;
  neededForBoot = true;
}
