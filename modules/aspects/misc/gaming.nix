{
  flake-file.inputs.nix-gaming.url = "github:fufexan/nix-gaming";

  den.aspects.misc.gaming = {
    nixos =
      { lib, pkgs, ... }:
      {
        environment.persistence."/nix/persist".directories = lib.mkAfter [ ".steam" ];

        hardware.steam-hardware.enable = true;
        programs = {
          gamemode.enable = true;
          steam = {
            enable = true;
            dedicatedServer.openFirewall = false;
            extraCompatPackages = with pkgs; [ proton-ge-bin ];
            extraPackages = with pkgs; [
              mangohud
              gamescope
            ];
            localNetworkGameTransfers.openFirewall = true;
            gamescopeSession.enable = true;
            protontricks.enable = true;
            remotePlay.openFirewall = true;
          };
        };
      };

    provides.to-users.homeManager =
      { pkgs, ... }:
      {
        services.ludusavi.enable = true;
        programs = {
          mangohud.enable = true;
        };
        home.packages = with pkgs; [
          #bottles
          umu-launcher
          goverlay
          inotify-info
          #nyrna
          #xorg-xwininfo
          prismlauncher
          protonup-qt
          vkd3d-proton
          vkbasalt
          winetricks
        ];
        /*
          wineWowPackages.staging
            wineWowPackages.waylandFull
            wineWowPackages.fonts
        */
      };
  };
}
