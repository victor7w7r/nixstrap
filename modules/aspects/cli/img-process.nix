{ lib, ... }:
{
  den.aspects.cli.img-process = {
    os =
      { pkgs, ... }:
      {
        environment.systemPackages =
          with pkgs;
          lib.optionals [
            asciinema-agg
            catimg
            dipc
            feh
            imgcat
            jp2a
            lsix
            mediainfo
            slides
            timg
            ttygif
            vhs
          ];
      };
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          jfbview
          tuicam
        ];
      };
  };
}
