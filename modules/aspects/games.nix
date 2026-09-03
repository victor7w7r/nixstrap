{ inputs, ... }:
{
  flake-file.inputs.ponysay.url = "github:CrystalSplitter/ponysay-modern";

  den.aspects.games = {
    os =
      {
        isPersistent,
        lib,
        pkgs,
        self',
        ...
      }:
      {
        environment.systemPackages =
          with pkgs;
          with self'.packages;
          [
            asciiquarium-transparent
            cmatrix
            genact
            lavat
            neo-cowsay
            pipes-rs
            sl
            ternimal
          ]
          ++ lib.optionals isPersistent [
            aalib
            astroterm
            cemetery-escape
            chess-tui
            #cli-of-life
            clidle
            cfonts
            go-life
            nbsdgames
            neo
            paclear
            sandscreen
            sxtetris
            terminaltexteffects
            tmatrix
            toilet
            tty-solitaire
          ];
      };

    nixos =
      {
        isPersistent,
        lib,
        isX86,
        pkgs,
        self',
        ...
      }:
      {
        environment.systemPackages =
          with pkgs;
          with self'.packages;
          lib.optionals isPersistent [
            bollywood
            chalk-animation
            conway-screensaver
            dvdbounce
            dvdts
            gof-rs
            ncmatrix
            no-more-secrets
            rbonsai
            termsaver
            tuime
            #tui-slides
            scope-tui
            cointop
            clock-rs
            ticker
          ]
          ++ (lib.optionals isX86 [ inputs.ponysay.packages.x86_64-linux.default ]);
      };
  };
}
