{
  hasHome ? false,
}:
let
  builder = subvol: {
    device = "/dev/mapper/vg0-system";
    fsType = "btrfs";
    options = [
      "lazytime"
      "noatime"
      "discard=async"
      "compress-force=ztd:2"
      "subvol=/${subvol}"
    ];
    neededForBoot = true;
  };
in
{
  "/etc" = builder "/etc";
  "/root" = builder "/root";
  "/.snaps" = builder "/snaps";
}
// (if hasHome then { "/home" = builder "/home"; } else { })
