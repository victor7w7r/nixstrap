{ pkgs, ... }:
{
  home.packages = (
    with pkgs;
    [
      axel
      lan-mouse
      legcord
      mailspring
      mtr-gui
      music-discord-rpc
      vesktop
      (pkgs.callPackage ./custom/jdownloader.nix { })
      #franz
      #https://github.com/almahdi/nix-thorium
      #https://github.com/abdularis/LAN-Share
      #https://github.com/opeolluwa/beats
    ]
  );

}
