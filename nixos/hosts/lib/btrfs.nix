{
  subvol ? "",
  isNix ? false,
  depends ? [ ],
  device ? "/dev/vg0/system",
  hasSubvol ? true,
}:
{
  fsType = "btrfs";
  options = [
    "lazytime"
    "noatime"
    "compress=zstd:1"
    "discard=async"
  ]
  ++ (if isNix then [ "noacl" ] else [ ])
  ++ (if hasSubvol then [ "subvol=@${subvol}" ] else [ ]);
  inherit device depends;
  neededForBoot = true;
}
