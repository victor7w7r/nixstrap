{
  pkgs,
  inputs,
  host,
  ...
}:
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
      woeusb-ng
      #ventoy-full-qt
      #https://aur.archlinux.org/packages/repair-usb-disc-gtk4
    ]
    ++ (
      if host == "v7w7r-macmini81" then
        [
          inputs.gestures.packages."x86_64-linux".gestures
          (pkgs.callPackage ./custom/tablet-map.nix { })
        ]
      else
        [ ]
    )
    ++ (if system != "aarch64-linux" then [ usbimager ] else [ ])
  );
}
// (
  if host == "v7w7r-macmini81" then
    {
      xdg.configFile."gestures.kdl".text =
        ''swipe direction="any" fingers=3 mouse-up-delay=500 acceleration=10'';
      systemd.user.services.gestures = {
        Service = {
          ExecStart = "${inputs.gestures.packages."x86_64-linux".gestures}/bin/gestures start";
          ExecReload = "${inputs.gestures.packages."x86_64-linux".gestures}/bin/gestures reload";
          Restart = "no";
          StandardOutput = "journal";
          StandardError = "journal";
        };
        Install.WantedBy = [ "default.target" ];
      };
      systemd.user.services.tablet-map = {
        Service = {
          ExecStart = "${(pkgs.callPackage ./custom/tablet-map.nix { })}/bin/tablet_map";
          Restart = "no";
          StandardOutput = "journal";
          StandardError = "journal";
        };
        Install.WantedBy = [ "default.target" ];
      };
    }
  else
    { }
)
