{
  size ? "10G",
  isSolid ? false,
}:
(import ../lib/btrfs.nix) {
  inherit size isSolid;
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
