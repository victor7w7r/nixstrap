{ pkgs, host, ... }:
{
  programs.zen-browser = {
    enable = host != "v7w7r-youyeetoox1";
    setAsDefaultBrowser = true;
    policies = (import ./policies.nix);
    nativeMessagingHosts = with pkgs; [ kdePackages.plasma-browser-integration ];
    languagePacks = [ "es-ES" ];
    profiles.default = {
      id = 0;
      isDefault = true;
      name = "default";
      spacesForce = true;
      pinsForce = true;
      spaces = {
        Default = {
          id = "1d674ff6-8b4f-4cfb-9635-c7d569280a0b";
          icon = "";
          position = 1000;
          theme = {
            colors = [
              {
                red = 63;
                green = 3;
                blue = 10;
                algorithm = "floating";
                type = "explicit-lightness";
              }
            ];
            opacity = 0.9;
            texture = 0.5;
          };
        };
      };
    };
  };

  imports = [
    ./bookmarks.nix
    ./extensions.nix
    ./mods.nix
    ./search.nix
    ./settings.nix
  ];
}
