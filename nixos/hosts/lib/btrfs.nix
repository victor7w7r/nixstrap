{
  subvol ? "",
  isNix ? false,
  depends ? [ ],
  device ? "/dev/vg0/system",
  hasSubvol ? true,
  isLzo ? false,
}:
{
  fsType = "btrfs";
  options = [
    "lazytime"
    "noatime"
    "discard=async"
  ]
  ++ (if isNix then [ "noacl" ] else [ ])
  ++ (if hasSubvol then [ "subvol=@${subvol}" ] else [ ])
  ++ (if isLzo then [ "compress=lzo" ] else [ "compress=zstd:1" ]);
  inherit device depends;
  neededForBoot = true;
}
