{ inputs, ... }:
{
  flake-file.inputs.plasma-manager = {
    url = "github:nix-community/plasma-manager";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.home-manager.follows = "home-manager";
  };

  den.aspects.plasma.default-config =
    { user, ... }:
    {
      nixos =
        { pkgs, lib, ... }:
        {
          programs.kde-pim.enable = true;

          environment.persistence."/nix/persist".users."${user.name}" = {
            directories = [
              ".local/share/baloo"
              ".local/share/klipper"
              ".local/share/krdc"
              ".local/share/kwalletd"
            ];
            files = [
              ".config/kwalletrc"
              ".config/kwinoutputconfig.json"
            ];
          };

          security.pam.services."victor7w7r".kwallet = {
            enable = true;
            package = pkgs.kdePackages.kwallet-pam;
          };

          services.desktopManager.plasma6 = {
            enable = true;
            enableQt5Integration = true;
          };

          xdg.portal = {
            enable = true;
            config = lib.mkForce {
              common = {
                default = [
                  "kde"
                  "*"
                ];
              };
            };
          };
        };

      provides.to-users.homeManager =
        { pkgs, ... }:
        {
          imports = [ inputs.plasma-manager.homeModules.plasma-manager ];

          programs.plasma = {
            enable = true;
            overrideConfig = true;
            session = {
              general.askForConfirmationOnLogout = false;
              #sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession";
            };
            shortcuts."KDE Keyboard Layout Switcher"."Switch to Next Keyboard Layout" = "Meta+Space";
            configFile = {
              plasma-localerc.Formats.LANG = "es_ES.UTF-8";
              kded5rc.Module-device_automounter.autoload = false;
              baloofilerc."Basic Settings"."Indexing-Enabled" = false;
              gwenviewrc.ThumbnailView.AutoplayVideos = true;
            };
          };

          services = {
            kdeconnect.enable = true;
            gpg-agent = {
              pinentry.package = pkgs.kwalletcli;
              enableSshSupport = true;
              defaultCacheTtl = 34560000;
              maxCacheTtl = 34560000;
              extraConfig = "pinentry-program ${pkgs.kwalletcli}/bin/pinentry-kwallet";
            };
          };
        };
    };
}
