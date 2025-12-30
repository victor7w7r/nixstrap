{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    catimg
    feh
    imgcat
    jfbview
    lsix
    mediainfo
    timg
    tuicam

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

    asciinema-agg
    dipc
    jp2a
    slides
    ttygif
    vhs

    #spotify-adblock-git
    #spotify-adkiller-dns-block-git
    #https://github.com/carlocastoldi/blockify
    #https://github.com/islemci/cliwrap
    #https://github.com/lyricstify/lyricstify
    #https://github.com/trizen/clyrics
    #https://github.com/abs3ntdev/gspot
    #https://github.com/mkckr0/audio-share
    #https://github.com/gdzx/audiosource
    #https://github.com/SathyaBhat/spotify-dl
    #https://github.com/foresterre/imagineer
  ];
}
