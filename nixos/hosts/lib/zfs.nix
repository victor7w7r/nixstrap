{
  dataset ? "root",
  preDataset ? "safe",
  pool ? "zroot",
  neededForBoot ? true,
}:
{
  device = "${pool}/${preDataset}/${dataset}";
  fsType = "zfs";
  options = [
    "atime=off"
  ];
  inherit neededForBoot;
}
