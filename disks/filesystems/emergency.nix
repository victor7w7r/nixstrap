{
  size ? "3G",
  name ? "emergency",
  mountpoint ? "/boot/emergency",
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
  type = "8300";
  mountOptions = [ "compress-force=zstd" ];
}
