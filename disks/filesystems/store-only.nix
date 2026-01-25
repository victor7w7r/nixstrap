{
  size ? "90G",
}:
(import ../lib/xfs.nix) {
  inherit size;
  name = "store";
  label = "store";
  lvmPool = "thinpool";
  mountpoint = "/nix";
}
