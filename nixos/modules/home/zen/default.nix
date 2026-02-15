{
  config,
  inputs,
  pkgs,
  system,
  ...
}:
let
  policies = import ./policies.nix;
  location = ".zen/default/chrome";
  zen = import ./custom/zen.nix { inherit policies system inputs; };
in
{
  home.file = {
    "${location}/JS/engine" = {
      source = inputs.sine + "/engine";
      recursive = true;
    };
    "${location}/JS/sine.sys.mjs" = {
      source = inputs.sine + "/sine.sys.mjs";
      recursive = false;
    };
    "${location}/utils" = {
      source = inputs.sine-bootloader + "/profile/utils";
      recursive = true;
    };
    "${location}/locales" = {
      source = inputs.sine + "/locales";
      recursive = true;
    };
  };

  programs.zen-browser = {
    enable = true;
    package = (config.lib.nixGL.wrap ((pkgs.wrapFirefox) zen { }));
    nativeMessagingHosts = [ pkgs.firefoxpwa ];
    languagePacks = [ "es-ES" ];
    profiles.default = {
      id = 0;
      name = "default";
      spacesForce = true;
      pinsForce = true;
      pins = {
        "GitHub" = {
          id = "48e8a119-5a14-4826-9545-91c8e8dd3bf6";
          url = "https://github.com";
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

  #zen-browser-sponsorblock zen-browser-ublock-origin zen-browser-dark-reader zen-browser-violentmonkey
  imports = [
    (import ./bookmarks.nix)
    (import ./extensions.nix)
    (import ./mods.nix)
    (import ./settings.nix)
    (import ./search.nix)
  ];
}
