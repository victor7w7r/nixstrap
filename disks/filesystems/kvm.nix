(import ../lib/btrfs.nix) {
  name = "kvm";
  size = "100%";
  label = "kvm";
  mountpoint = "/kvm";
}
