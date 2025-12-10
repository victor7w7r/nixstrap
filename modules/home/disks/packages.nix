{ pkgs, ... }:
{
  home.packages = (
    with pkgs;
    [
      btrfs-assistant
      ddrescueview
      gparted
      qdiskinfo
      snapper-gui
      testdisk-qt
      usbimager
      #ventoy-full-qt
      woeusb-ng
      #https://aur.archlinux.org/packages/repair-usb-disc-gtk4
    ]
  );
}
