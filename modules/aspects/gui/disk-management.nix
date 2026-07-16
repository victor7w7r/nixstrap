{ __findFile, ... }:
{
  den.aspects.gui.disk-management = {
    /*
      includes = [
      (<den/insecure> [
        "qtwebengine-5.15.19"
        "ventoy-qt5-1.1.10"
        "ventoy-qt5-1.1.12"
        "electron-39.8.10"
      ])
      ];
    */

    provides.to-users.homeManager =
      { pkgs, self', ... }:
      {
        home.packages = with pkgs; [
          btrfs-assistant
          ddrescueview
          gparted
          qdiskinfo
          snapper-gui
          testdisk-qt
          woeusb-ng
          #ventoy-full-qt
          self'.packages.repair-usb-disc-gtk4
        ];
      };
  };
}
