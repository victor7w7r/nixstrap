{ inputs, pkgs, ... }:
let
  chrome = pkgs.stdenv.mkDerivation {
    pname = "chrome-zen";
    version = "1.0";
    src_1 = inputs.nebula-zen;
    src_2 = inputs.sine-bootloader;

    buildInputs = [ pkgs.jq ];

    installPhase = ''
      mkdir -p $out/JS

      cp --no-preserve=mode -r ${inputs.sine}/{sine.sys.mjs,engine} $out/JS
      cp --no-preserve=mode -r $src_2/profile/utils ${inputs.sine}/locales $out

      mkdir -p $out/sine-mods
      cp --no-preserve=mode -r $src_1 $out/sine-mods/Nebula
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
      cp --no-preserve=mode ${pkgs.nixos-icons}/share/icons/hicolor/1024x1024/apps/nix-snowflake.png \
        $out/sine-mods/Nebula/Nebula/modules
      substituteInPlace $out/sine-mods/Nebula/Nebula/modules/Topbar-buttons.css \
        --replace-fail "url(\"chrome://branding/content/about-logo.svg\")" "url(\"nix-snowflake.png\")" \
        --replace-fail "scale: 1.7;" "scale: 1.1;"
    '';
  };

  zen-unwrap =
    (inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.beta-unwrapped.override {
      policies = (import ./policies.nix);
    }).overrideAttrs
      (prev: {
        postInstall = prev.postInstall or "" + ''
          chmod -R u+w "$out/lib/zen-bin-${prev.version}"
          cp -r "${inputs.sine-bootloader}/program/"* "$out/lib/zen-bin-${prev.version}"
        '';
      });
in
{
  inherit chrome;
  zen-wrap = (pkgs.wrapFirefox zen-unwrap { icon = "zen-browser"; }).override {
    nativeMessagingHosts = [ pkgs.pywalfox-native ];
  };
}
