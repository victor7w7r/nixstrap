{ pkgs, ... }:
{
  home.packages = (
    with pkgs;
    [
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
