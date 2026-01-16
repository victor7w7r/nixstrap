{ pkgs, ... }:
{
  home.packages = (
    with pkgs;
    [
      btrfs-assistant
      cpu-x
      ddrescueview
      git-credential-manager
      qdiskinfo
      testdisk-qt
      usbimager
      woeusb-ng
    ]
  );
}
