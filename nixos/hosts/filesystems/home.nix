{
  "/home" = {
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
}
