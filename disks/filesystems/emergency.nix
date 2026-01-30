{
  size ? "3G",
  name ? "emergency",
  mountpoint ? "/boot/emergency",
  isSolid ? true,
  priority ? 2,
}:
(import ../lib/btrfs.nix) {
  inherit
    name
    size
    priority
    mountpoint
    ;
  label = "emergency";
  mountOptions = [
    "lazytime"
    "noatime"
    "compress=zstd"
  ]
  ++ (if isSolid then [ "discard=async" ] else [ "autodefrag" ]);
}
