{ pkgs, ... }:
{
  environment.defaultPackages =
    with pkgs;
    [
      cava
      dipc
      ffmpeg
      imagemagick
      kew
      musikcube
      ncspot
      picard
    ]
    + [
      aalib
      asciiquarium
      astroterm
      cbonsai
      cmatrix
      genact
      lavat
      nbsdgames
      pipes-rs
      sl
      toilet
      tty-solitaire
    ];
}
