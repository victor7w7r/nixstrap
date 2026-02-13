{ inputs, pkgs, ... }:
let
  chrome = pkgs.stdenv.mkDerivation {
    pname = "chrome-zen";
    version = "1.0";

    src = inputs.sine;
    src_1 = inputs.nebula-zen;
    src_2 = inputs.sine-bootloader;

    buildInputs = [ pkgs.jq ];

    installPhase = ''
      mkdir -p $out/JS
      cp -r $src/{sine.sys.mjs,engine} $out/JS
      cp -r $src_2/profile/utils $out
      cp -r $src/locales $out
      chmod -R +w $out
      mkdir -p $out/sine-mods/Nebula
      echo "{}" > $out/sine-mods/mods.json
      jq --arg key "Nebula" --slurpfile new $src_1/theme.json  \
        '.[$key] = ($new[0] + {
          "stars": 1233,
          "origin": "store",
          "preferences": "preferences.json",
          "no-updates": false,
          "enabled": true
        })' $out/sine-mods/mods.json > $out/sine-mods/mods.json.tmp && mv $out/sine-mods/mods.json.tmp $out/sine-mods/mods.json
      cp $src_1/JS/Nebula.uc.js $out/JS/Nebula_Nebula.uc.js
      cp -r $src_1/{Nebula,userChrome.css,userContent.css,preferences.json} $out/sine-mods/Nebula
      chmod +w $out/sine-mods/Nebula/Nebula/modules
      cp ${pkgs.nixos-icons}/share/icons/hicolor/1024x1024/apps/nix-snowflake.png $out/sine-mods/Nebula/Nebula/modules
      chmod +w $out/sine-mods/Nebula/Nebula/modules/Topbar-buttons.css
      substituteInPlace $out/sine-mods/Nebula/Nebula/modules/Topbar-buttons.css \
        --replace-fail "url(\"chrome://branding/content/about-logo.svg\")" "url(\"nix-snowflake.png\")" \
        --replace-fail "scale: 1.7;" "scale: 1.5;" \
    '';
  };
  zen-package =
    (inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
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
      recursive = true;
      source = chrome;
    };
  };
  programs.zen-browser = {
    enable = true;
    /*
      package = (pkgs.wrapFirefox zen-package { icon = "zen-twilight"; }).override {
          extraPrefs = cfg_orig.extraPrefs;
             extraPrefsFiles = cfg_orig.extraPrefsFiles;
             nativeMessagingHosts = cfg_orig.nativeMessagingHosts;

      };
    */
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
