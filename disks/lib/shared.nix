{
  name ? "shared",
  size ? "100%",
  priority ? 100,
  isSolid ? true,
  mountContent ? "shared",
  mountSnap ? "sharedsnaps",
}:
(import ../lib/btrfs.nix) {
  inherit
    name
    size
    priority
    ;
  mountOptions = [
    "lazytime"
    "noatime"
    "compress-force=zstd:2"
  ]
  ++ (if isSolid then [ "discard=async" ] else [ "autodefrag" ]);

  subvolumes = {
    "/${mountContent}".mountpoint = "/run/media/${mountContent}";
    "/.${mountSnap}".mountpoint = "/run/media/.${mountSnap}";
  };
}
