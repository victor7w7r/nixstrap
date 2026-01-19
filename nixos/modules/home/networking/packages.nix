{ pkgs, ... }:
{
  home.packages = (
    with pkgs;
    [
      axel
      ayugram-desktop
      lan-mouse
      legcord
      mailspring
      media-downloader
      mtr-gui
      music-discord-rpc
      persepolis
      vesktop
      (pkgs.callPackage ./custom/jdownloader.nix { })
      #franz
      #https://github.com/almahdi/nix-thorium
      #https://github.com/abdularis/LAN-Share
      #https://github.com/opeolluwa/beats
    ]
  );

}
