{ pkgs, host, ... }:
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
// (
  if host == "v7w7r-macmini81" then
    {
      systemd.user.services.tablet-map = {
        Unit = {
          Description = "Tablet Map Service for Wacom Intuos5";
        };
        Service = {
          ExecStart = "${(pkgs.callPackage ./custom/tablet-map.nix { })}/bin/tablet-map";
          Restart = "no";
          StandardOutput = "journal";
          StandardError = "journal";
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };
    }
  else
    { }
)
