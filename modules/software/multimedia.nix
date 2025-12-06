{ pkgs, ... }:

{
  home.packages = (
    with pkgs;
    [
      kew
      linuxwave
      musikcube
      #spotify-adblock-git
      #spotify-adkiller-dns-block-git
      playerctl
      #https://github.com/carlocastoldi/blockify
      #https://github.com/islemci/cliwrap
      # https://github.com/lyricstify/lyricstify
      ytfzf
      #https://github.com/trizen/clyrics
      #https://github.com/abs3ntdev/gspot
      #https://github.com/mkckr0/audio-share
      # https://github.com/gdzx/audiosource
      psst
      spotdl
      youtube-tui
      spotify-qt
      #https://github.com/SathyaBhat/spotify-dl
      sptlrx
      ytmdl

      dipc
      #https://github.com/foresterre/imagineer
      asciinema-agg
      slides
      ttygif
      vhs

    ]
  );

  programs.ncspot.enable = true;
  programs.cava.enable = true;
  programs.asciinema.enable = true;

}
