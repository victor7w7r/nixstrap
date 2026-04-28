{
  depends ? [ ],
  device ? "/dev/vg0/persist",
  isSolid ? false,
}:
{
  fsType = "xfs";
  options = [
    "noatime"
    "nodiratime"
    "lazytime"
    "logbufs=8"
    "logbsize=256k"
  ] ++ (if isSolid then [ "discard" ] else [ ]);
  inherit device depends;
  neededForBoot = true;
}
