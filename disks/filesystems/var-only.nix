{
  size ? "5G",
}:
(import ../lib/btrfs.nix) {
  inherit size;
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
