{
  flake-file.inputs.custom-packages.url = "github:Rishabh5321/custom-packages-flake";

  den.aspects.gui.extras =
    { lib, user, ... }:
    {
      nixos =
        { isPersistent, isServer, ... }:
        lib.optionalAttrs (isPersistent && !isServer) {
          environment.persistence."/nix/persist".users."${user.name}".directories = lib.mkAfter [
            ".config/legcord"
            ".config/onlyoffice"
            ".config/vlc"
            ".local/share/PrismLauncher"
            ".local/share/com.vixalien.sticky"
            ".local/share/onlyoffice"
            ".local/share/vlc"
          ];
        };

      provides.to-users.homeManager =
        {
          isPersistent,
          isServer,
          isX86,
          pkgs,
          self',
          ...
        }:
        lib.optionalAttrs (isPersistent && !isServer) {
          programs.onlyoffice.enable = true;
          home.packages =
            with pkgs;
            [
              bleachbit
              chromium
              clamtk
              cool-retro-term
              cpu-x
              #czkawka-full
              #davinci-resolve
              fclones-gui
              inkscape-with-extensions
              kopia-ui
              kid3-kde
              lan-mouse
              #legcord
              lightworks
              lunacy
              #mailspring
              media-downloader
              meld
              mission-center
              morphosis
              mtr-gui
              music-discord-rpc
              #natron
              pinta
              rclone-browser
              rnote
              seafile-client
              sonic-visualiser
              spotify-qt
              sticky-notes
              tenacity
              vlc
              self'.packages.davinci-video-converter
              self'.packages.fzf-open
              self'.packages.jdownloader
              self'.packages.linuxthemestore
              self'.packages.shutter-encoder
              self'.packages.tahoma2d
              self'.packages.ytdl
            ]
            ++ (lib.optionals isX86 [
              #inputs'.custom-packages.packages.${pkgs.stdenv.hostPlatform.system}.thorium-sse3
            ]);
        };
    };
}
