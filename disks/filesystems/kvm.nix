(import ../lib/xfs.nix) {
  name = "kvm";
  size = "100%";
  label = "kvm";
  lvm_type = "thinlv";
  pool = "thinpool";
  mountpoint = "/kvm";
}
