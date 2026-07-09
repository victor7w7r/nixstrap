{ inputs, ... }:
{
  flake-file.inputs.ponysay.url = "github:CrystalSplitter/ponysay-modern";

  den.default = {
    os =
      {
        isPersistent,
        lib,
        pkgs,
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
            nbsdgames
            neo-cowsay
            pipes-rs
            sl
            ternimal
          ]
          ++ lib.optionals isPersistent [
            aalib
            astroterm
            cementery-escape
            chess-tui
            cli-of-life
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
        pkgs,
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
            fortune-anti-jokes
            fortune-mod-archlinux
            fortune-mod-anarchism
            fortune-mod-bofh-excuses
            fortune-mod-billwurtz
            fortune-mod-canada-nctr
            fortune-mod-calvin
            fortune-mod-confucius
            fortune-mod-darkknight
            fortune-mod-dhammapada
            fortune-mod-doctorwho-classic-series
            fortune-mod-doctorwho-new-series
            fortune-mod-es
            fortune-mod-futurama
            fortune-mod-g
            fortune-mod-helluva
            fortune-mod-husse
            fortune-mod-issa-haiku
            fortune-mod-leftism
            fortune-mod-limetricks
            fortune-mod-matrix
            fortune-mod-portal-game
            fortune-mod-protolol
            fortune-mod-starwars
            fortune-mod-vimtips
            gof-rs
            lifecycler
            ncmatrix
            no-more-secrets
            rbonsai
            termsaver
            tuime
            tui-slides
            scope-tui
            cointop
            clock-rs
            ticker
            inputs.ponysay.packages.x86_64-linux.default
          ];
      };
  };
}
