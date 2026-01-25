let
  builder = subvol: {
    device = "/dev/mapper/vg0-fs";
    fsType = "btrfs";
    options = [
      "nodatacow"
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
}
