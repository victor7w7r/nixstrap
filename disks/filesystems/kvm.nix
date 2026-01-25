(import ../lib/xfs.nix) {
  name = "kvm";
  size = "100%";
  label = "kvm";
  lvmPool = "thinpool";
  mountpoint = "/kvm";
}
