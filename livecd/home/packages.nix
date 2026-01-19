{ pkgs, ... }:
{
  home.packages = (
    with pkgs;
    [
      btrfs-assistant
      cpu-x
      ddrescueview
      qdiskinfo
      usbimager
      woeusb-ng
    ]
  );
}
