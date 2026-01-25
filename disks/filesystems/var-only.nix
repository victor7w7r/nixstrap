{
  size ? "5G",
  isSolid ? false,
}:
(import ../lib/btrfs.nix) {
  inherit size isSolid;
  name = "var";
  label = "var";
  lvmPool = "thinpool";
  mountpoint = "/var";
  mountOptions = [
    "nodatacow"
    "lazytime"
    "noatime"
  ];
}
