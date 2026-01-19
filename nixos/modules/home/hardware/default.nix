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
      woeusb-ng
      #ventoy-full-qt
      #https://aur.archlinux.org/packages/repair-usb-disc-gtk4
    ]
  );
}
