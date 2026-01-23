{
  size ? "100%",
  name ? "Shared",
  mountContent ? "/media/shared",
  mountSnap ? "/media/.shared-snapshots",
  priority ? 100,
  label ? "shared",
}:
{
  inherit name size priority;
  type = "8300";
  content = {
    type = "btrfs";
    extraArgs = [
      "-f"
      "-L ${label}"
    ];
    mountOptions = [
      "lazytime"
      "noatime"
      "discard=async"
      "space_cache=v2"
      "compress-force=zstd:2"
    ];
    subvolumes = {
      mountContent.mountpoint = mountContent;
      mountSnap.mountpoint = mountSnap;
    };
  };
}
