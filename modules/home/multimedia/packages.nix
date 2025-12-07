{ pkgs, ... }:
{
  home.packages = (
    with pkgs;
    [
      kid3-kde
      media-downloader
      spotify-qt
      vlc
      vlc-bittorrent
      #vlc-pause-click-plugin vlc-plugin-pipewire vlc-plugin vlc-plugins-all vlc-plugin-ytdl-git
      #https://github.com/codewithmoss/ytdl
      #https://github.com/Shabinder/SpotiFlyer
      #https://davidepucci.it/doc/spotitube/#installation
    ]
  );
}
