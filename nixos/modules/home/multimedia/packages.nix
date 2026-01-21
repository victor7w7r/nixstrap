{ pkgs, ... }:
{
  home.packages = (
    with pkgs;
    [
      kid3-kde
      media-downloader
      spotify-qt
      vlc
      (pkgs.callPackage ./custom/ytdl.nix { })
      #vlc-pause-click-plugin vlc-plugin-pipewire vlc-plugin vlc-plugins-all vlc-plugin-ytdl-git
      #https://github.com/Shabinder/SpotiFlyer
      #https://davidepucci.it/doc/spotitube/#installation
    ]
    ++ [
      easyeffects
      calf
      lsp-plugins
      zam-plugins
      mda_lv2
      #easyeffects-bundy01-presets easyeffects-jtrv-presets-git
    ]
    ++ [
      tenacity
      #davinci-resolve
      #inkscape-with-extensions
      #lightworks
      #lunacy
      #natron
      #sonic-visualiser
      # https://github.com/paulpacifico/shutter-encoder
      #https://github.com/tkmxqrdxddd/davinci-video-converter
      #https://tahoma2d.org/
    ]
  );
}
