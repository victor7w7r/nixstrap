{
  dataset ? "root",
  pool ? "zroot",
}:
{
  device = "${pool}/local/${dataset}";
  fsType = "zfs";
  options = [
    "zfsutil"
    "atime=off"
  ];
  neededForBoot = true;
}
