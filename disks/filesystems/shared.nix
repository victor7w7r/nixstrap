{
  name ? "shared",
  size ? "100%",
  label ? "shared",
  priority ? 100,
  mountContent ? "shared",
  mountSnap ? "sharedsnaps",
}:
(import ../lib/btrfs.nix) {
  inherit
    name
    size
    priority
    label
    ;
  type = "8300";
  mountOptions = [ "compress-force=ztd:2" ];
  subvolumes = {
    "/${mountContent}".mountpoint = "/run/media/${mountContent}";
    "/.${mountSnap}".mountpoint = "/run/media/.${mountSnap}";
  };
}
