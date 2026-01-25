{
  size ? "10G",
}:
(import ../lib/btrfs.nix) {
  inherit size;
  name = "home";
  label = "home";
  lvm_type = "thinlv";
  pool = "thinpool";
  mountpoint = "/home";
  postMountHook = "mkdir -p /home/common";
  subvolumes = {
    "/home".mountpoint = "/home";
    "/homesnaps".mountpoint = "/home/.homesnaps";
  };
}
