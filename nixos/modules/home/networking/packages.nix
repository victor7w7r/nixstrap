{ system, pkgs, ... }:
{
  home.packages = (
    with pkgs;
    [
      axel
      #ayugram-desktop
      lan-mouse
      legcord
      media-downloader
      mtr-gui
      music-discord-rpc
      (pkgs.callPackage ./custom/jdownloader.nix { })
      #franz
      #https://github.com/abdularis/LAN-Share
      #https://github.com/opeolluwa/beats
    ]
    ++ (if system != "aarch64-linux" then [ mailspring ] else [ ])
  );

}
