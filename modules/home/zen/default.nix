{ pkgs, ... }:
{
  programs.zen-browser = {
    enable = true;
    languagePacks = [ "es-ES" ];
    nativeMessagingHosts = [pkgs.firefoxpwa];
    profiles.default = {
      id = 0;
      name = "default";
      spacesForce = true;
      pinsForce = true;
      pins = {
        "GitHub" = {
          id = "7fb14076-a147-4d09-8487-bdd830332b61";
          workspace = spaces."DefaultSpace".id;
          url = "https://github.com";
          position = 100;
          isEssential = true;
        };
        "Deepseek" = {
          id = "4ecfbb32-81eb-4a5f-ab1a-68b3ebf1f5fa";
          workspace = spaces."DefaultSpace".id;
          url = "https://chat.deepseek.com/";
          position = 101;
          isEssential = true;
        };
      };
      spaces = {
        "DefaultSpace" = {
          id = "1d674ff6-8b4f-4cfb-9635-c7d569280a0b";
          icon = "";
          position = 1000;
        };
      };
      isDefault = true;
      userChrome = builtins.readFile ./userChrome.css;
      userContent = builtins.readFile ./userContent.css;
      extraConfig = ''
        ${builtins.readFile "${inputs.betterfox}/Fastfox.js"}
        ${builtins.readFile "${inputs.betterfox}/Peskyfox.js"}
        ${builtins.readFile "${inputs.betterfox}/Securefox.js"}
        ${builtins.readFile "${inputs.betterfox}/Smoothfox.js"}
      '';
    };
  };

  xdg.configFile."mimeapps.list".force = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "zen.desktop";
      "x-scheme-handler/http" = "zen.desktop";
      "x-scheme-handler/https" = "zen.desktop";
      "x-scheme-handler/about" = "zen.desktop";
      "x-scheme-handler/unknown" = "zen.desktop";
      "application/x-extension-htm" = "zen.desktop";
      "application/x-extension-html" = "zen.desktop";
      "application/x-extension-shtml" = "zen.desktop";
      "application/x-extension-xht" = "zen.desktop";
      "application/x-extension-xhtml" = "zen.desktop";
      "application/xhtml+xml" = "zen.desktop";
    };
  };

  #zen-browser-sponsorblock zen-browser-ublock-origin zen-browser-dark-reader zen-browser-violentmonkey
  imports = [
    (import ./bookmarks.nix)
    (import ./policies.nix)
    (import ./settings.nix)
    (import ./search.nix)
  ];
}
