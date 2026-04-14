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
      calf
      deepfilternet
      lsp-plugins
      libebur128
      #zam-plugins
      zita-convolver
      mda_lv2
      speexdsp
      soundtouch
      rnnoise
    ]
    ++ [
      tenacity
      #davinci-resolve
      inkscape-with-extensions
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
