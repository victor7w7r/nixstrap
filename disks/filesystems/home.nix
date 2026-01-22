{
  size ? "10G",
}:
(import ../lib/btrfs.nix) {
  inherit size;
  name = "home";
  label = "home";
  mountpoint = "/home";
  postMountHook = "mkdir -p /home/common";
}
