{
  size ? "5G",
  isSolid ? false,
}:
(import ../lib/btrfs.nix) {
  inherit size isSolid;
  name = "var";
  label = "var";
  lvm_type = "thinlv";
  pool = "thinpool";
  mountpoint = "/var";
  mountOptions = [
    "nodatacow"
    "lazytime"
    "noatime"
  ];
}
