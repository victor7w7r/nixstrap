{
  disk ? "main",
  name ? "emergency",
}:
{
  "/boot" = {
    device = "/dev/disk/by-partlabel/disk-main-EFI";
    fsType = "vfat";
    options = [
      "lazytime"
      "noatime"
      "umask=0077"
      "dmask=0077"
      "codepage=437"
      "iocharset=ascii"
      "shortname=mixed"
      "errors=remount-ro"
      "nofail"
    ];
  };
  "/boot/emergency" = {
    device = "/dev/disk/by-partlabel/disk-${disk}-${name}";
    fsType = "btrfs";
    options = [
      "lazytime"
      "noatime"
      "commit=60"
      "discard=async"
      "space_cache=v2"
      "compress-force=zstd"
    ];
    depends = [ "/boot" ];
  };
}
