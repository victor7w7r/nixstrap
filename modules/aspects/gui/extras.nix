{
  flake-file.inputs.custom-packages.url = "github:Rishabh5321/custom-packages-flake";

  den.aspects.gui.extras =
    { user, ... }:
    {
      nixos =
        { lib, ... }@args:
        lib.optionalAttrs (args.isPersistent && !args.isServer) {
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
        { lib, pkgs, ... }@args:
        lib.optionalAttrs (args.isPersistent && !args.isServer) {
          programs.onlyoffice.enable = true;
          home.packages =
            with pkgs;
            with args.self'.packages;
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
              davinci-video-converter
              fzf-open
              jdownloader
              linuxthemestore
              shutter-encoder
              tahoma2d
              ytdl
            ]
            ++ (lib.optionals args.isX86 [
              #inputs'.custom-packages.packages.${pkgs.stdenv.hostPlatform.system}.thorium-sse3
            ]);
        };
    };
}
