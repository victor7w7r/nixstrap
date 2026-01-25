{
  name ? "vg0-store",
}:
{
  "/nix" = {
    device = "/dev/mapper/${name}";
    fsType = "xfs";
    neededForBoot = true;
    options = [
      "attr2"
      "noatime"
      "lazytime"
      "nodiscard"
      "logbsize=256k"
      "inode64"
    ];
  };
}
