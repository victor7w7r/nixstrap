{ inputs, ... }:
{
  flake-file.inputs.ponysay.url = "github:CrystalSplitter/ponysay-modern";

  den.default = {
    os =
      {
        pkgs,
        isPersistent,
        self',
        ...
      }:
      {
        environment.systemPackages =
          with pkgs;
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
            self'.packages.cementery-escape
            chess-tui
            self'.packages.cli-of-life
            self'.packages.clidle
            cfonts
            self'.packages.go-life
            nbsdgames
            neo
            self'.packages.paclear
            self'.packages.sandscreen
            self'.packages.sxtetris
            terminaltexteffects
            tmatrix
            toilet
            tty-solitaire
          ];
      };

    nixos =
      {
        isPersistent,
        self',
        pkgs,
        ...
      }:
      {
        environment.systemPackages =
          with pkgs;
          lib.optionals isPersistent [
            self'.packages.bollywood
            self'.packages.chalk-animation
            self'.packages.conway-screensaver
            self'.packages.dvdbounce
            self'.packages.dvdts
            self'.packages.fortune-anti-jokes
            self'.packages.fortune-mod-archlinux
            self'.packages.fortune-mod-anarchism
            self'.packages.fortune-mod-bofh-excuses
            self'.packages.fortune-mod-billwurtz
            self'.packages.fortune-mod-canada-nctr
            self'.packages.fortune-mod-calvin
            self'.packages.fortune-mod-confucius
            self'.packages.fortune-mod-darkknight
            self'.packages.fortune-mod-dhammapada
            self'.packages.fortune-mod-doctorwho-classic-series
            self'.packages.fortune-mod-doctorwho-new-series
            self'.packages.fortune-mod-es
            self'.packages.fortune-mod-futurama
            self'.packages.fortune-mod-g
            self'.packages.fortune-mod-helluva
            self'.packages.fortune-mod-husse
            self'.packages.fortune-mod-issa-haiku
            self'.packages.fortune-mod-leftism
            self'.packages.fortune-mod-limetricks
            self'.packages.fortune-mod-matrix
            self'.packages.fortune-mod-portal-game
            self'.packages.fortune-mod-protolol
            self'.packages.fortune-mod-starwars
            self'.packages.fortune-mod-vimtips
            self'.packages.gof-rs
            self'.packages.lifecycler
            self'.packages.ncmatrix
            self'.packages.no-more-secrets
            self'.packages.rbonsai
            self'.packages.termsaver
            self'.packages.tuime
            self'.packages.tui-slides
            scope-tui
            cointop
            clock-rs
            ticker
            inputs.ponysay.packages.x86_64-linux.default
          ];
      };
  };
}
