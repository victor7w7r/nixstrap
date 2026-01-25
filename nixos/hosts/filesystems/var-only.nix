{
  varName ? "vg0-var",
  isSolid ? false,
}:
{
  "/var" = {
    device = "/dev/mapper/${varName}";
    fsType = "var";
    neededForBoot = true;
    options = [
      "nodatacow"
      "lazytime"
      "noatime"
      "space_cache=v2"
    ]
    ++ (if isSolid then [ "discard=async" ] else [ "autodefrag" ]);
  };
}
