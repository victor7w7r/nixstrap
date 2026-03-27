{
  dataset ? "root",
  preDataset ? "safe",
  pool ? "zroot",
  depends ? [ ],
  neededForBoot ? true,
  options ? [ ],
}:
{
  device = "${pool}/${preDataset}/${dataset}";
  fsType = "zfs";
  options = [ "atime=off" ] ++ options;
  inherit neededForBoot depends;
}
