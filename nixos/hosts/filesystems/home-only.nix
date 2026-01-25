{
  name ? "vg0-home",
  isSolid ? false,
}:
let
  builder = subvol: {
    device = "/dev/mapper/${name}";
    fsType = "btrfs";
    options = [
      "lazytime"
      "noatime"
      "compress-force=ztd:2"
      "subvol=/${subvol}"
    ]
    ++ (if isSolid then [ "discard=async" ] else [ "autodefrag" ]);
    neededForBoot = true;
  };
in
{
  "/home" = builder "/home";
  "/.homesnaps" = builder "/root";
}
