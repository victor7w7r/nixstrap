{
  size ? "90G",
}:
(import ../lib/xfs.nix) {
  inherit size;
  name = "store";
  label = "store";
  lvm_type = "thinlv";
  pool = "thinpool";
  mountpoint = "/nix";
}
