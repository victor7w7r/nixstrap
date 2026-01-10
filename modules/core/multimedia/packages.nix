{ pkgs, ... }:
{
  environment.systemPackages =
    with pkgs;
    [
      catimg
      feh
      imgcat
      jfbview
      lsix
      mediainfo
      timg
      tuicam
    ]
    ++ [
      kew
      linuxwave
      musikcube
      playerctl
      psst
      spotdl
      sptlrx
      youtube-tui
      ytfzf
      ytmdl
    ]
    ++ [
      asciinema-agg
      dipc
      jp2a
      slides
      ttygif
      vhs
      (pkgs.callPackage ./custom/audio-share.nix { })
      (pkgs.callPackage ./custom/cliwrap.nix { })
      (pkgs.callPackage ./custom/lyricstify.nix { })
      (pkgs.callPackage ./custom/gspot.nix { })
      #spotify-adblock-git
      #spotify-adkiller-dns-block-git
      #https://github.com/carlocastoldi/blockify
      #https://github.com/trizen/clyrics
      #https://github.com/SathyaBhat/spotify-dl
      #https://github.com/foresterre/imagineer
    ];
}
