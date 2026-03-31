{
  config,
  inputs,
  pkgs,
  ...
}:
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
        })' $out/sine-mods/mods.json > $out/sine-mods/mods.json.tmp
      mv $out/sine-mods/mods.json.tmp $out/sine-mods/mods.json
      cp $src_1/JS/Nebula.uc.js $out/JS/Nebula_Nebula.uc.js
      cp $src_1/README.md $out/sine-mods/Nebula/readme.md
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
    (inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.beta-unwrapped.override {
      policies = config.programs.zen-browser.policies;
    }).overrideAttrs
      (prev: {
        postInstall = prev.postInstall or "" + ''
          chmod -R u+w "$out/lib/zen-bin-${prev.version}"
          cp -r "${inputs.sine-bootloader}/program/"* "$out/lib/zen-bin-${prev.version}"
        '';
      });
in
{
  xdg.configFile."zen/default/chrome" = {
    source = chrome;
    recursive = true;
  };

  programs.zen-browser.package = (pkgs.wrapFirefox zen-package { }).override {
    extraPrefs = config.programs.zen-browser.extraPrefs;
    extraPrefsFiles = config.programs.zen-browser.extraPrefsFiles;
    nativeMessagingHosts = config.programs.zen-browser.nativeMessagingHosts;
  };
}
