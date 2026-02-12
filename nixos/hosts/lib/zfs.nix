{
  dataset ? "root",
  preDataset ? "safe",
  pool ? "zroot",
}:
{
  device = "${pool}/${preDataset}/${dataset}";
  fsType = "zfs";
  options = [
    "zfsutil"
    "atime=off"
  ];
  neededForBoot = true;
}
