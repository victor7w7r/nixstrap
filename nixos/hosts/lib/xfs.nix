{
  depends ? [ ],
  device ? "/dev/vg0/persist",
  isSolid ? false,
  extraOptions ? []
}:
{
  fsType = "xfs";
  options = [
    "noatime"
    "nodiratime"
    "lazytime"
    "logbufs=8"
    "logbsize=256k"
    "x-systemd.device-timeout=0"
    "x-systemd.mount-timeout=0"
  ] ++ (if isSolid then [ "discard" ] else [ ]) ++ extraOptions;
  inherit device depends;
  neededForBoot = true;
}
