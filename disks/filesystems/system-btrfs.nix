{
  hasHome ? false,
  size ? "1G",
}:
(import ../lib/btrfs.nix) {
  inherit size;
  name = "system";
  label = "system";
  lvm_type = "thinlv";
  pool = "thinpool";
  postMountHook = if hasHome then "mkdir -p /home/common" else null;
  subvolumes = {
    "/etc".mountpoint = "/etc";
    "/root".mountpoint = "/root";
    "/snaps".mountpoint = "/.snaps";
  }
  // (if hasHome then { "/home".mountpoint = "/home"; } else { });
}
