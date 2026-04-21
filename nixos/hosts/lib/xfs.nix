{
  depends ? [ ],
  device ? "/dev/vg0/system",
}:
{
  fsType = "xfs";
  options = [
    "attr2"
    "noatime"
    "lazytime"
    "nodiscard"
    "logbsize=256k"
    "inode64"
  ];
  inherit device depends;
  neededForBoot = true;
}
