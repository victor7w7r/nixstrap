{ pkgs, ... }:
{
  home.packages = (
    with pkgs;
    [
      axel
      #franz
      lan-mouse
      legcord
      mailspring
      mtr-gui
      music-discord-rpc
      vesktop
      #https://github.com/almahdi/nix-thorium
      #https://aur.archlinux.org/packages/jdownloader2-jre
      #https://github.com/Tyrrrz/DiscordChatExporter
      #https://github.com/abdularis/LAN-Share
      #https://github.com/opeolluwa/beats
    ]
  );

}
