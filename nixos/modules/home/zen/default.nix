{ inputs, pkgs, ... }:
let
  zen-package =
    (inputs.zen-browser.packages.x86-64.default-twilight.override {
      #policies = cfg_orig.policies;
    }).overrideAttrs
      (prev: {
        postInstall = prev.postInstall or "" + ''
          chmod -R u+w "$out/lib/zen-bin-${prev.version}"
          cp -r "${inputs.sine-bootloader}/program/"* "$out/lib/zen-bin-${prev.version}"
        '';
      });
in
{
  home.file = {
    ".zen/default/chrome" = {
      source = import ./sine.nix;
      recursive = true;
    };
  };
  programs.zen-browser = {
    enable = true;
    package = (pkgs.wrapFirefox zen-package { icon = "zen-twilight"; }).override {
      /*
        extraPrefs = cfg_orig.extraPrefs;
           extraPrefsFiles = cfg_orig.extraPrefsFiles;
           nativeMessagingHosts = cfg_orig.nativeMessagingHosts;
      */
    };
    languagePacks = [ "es-ES" ];
    nativeMessagingHosts = [ pkgs.firefoxpwa ];
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
    (import ./policies.nix)
    (import ./settings.nix)
    (import ./search.nix)
  ];
}
