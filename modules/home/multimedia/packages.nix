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
    ++ [
      easyeffects
      # easyeffects-bundy01-presets easyeffects-jtrv-presets-git
      lsp-plugins
      calf
      zam-plugins
      mda_lv2
    ]
    ++ [
      #davinci-resolve
      #inkscape-with-extensions
      #lightworks
      #lunacy
      #natron
      #sonic-visualiser
      tenacity
      # https://github.com/paulpacifico/shutter-encoder
      #https://github.com/tkmxqrdxddd/davinci-video-converter
      #https://tahoma2d.org/
    ]
  );
}
