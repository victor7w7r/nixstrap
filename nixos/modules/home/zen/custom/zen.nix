{ pkgs, inputs, ... }:
let
  sine = import ./sine.nix { inherit pkgs; };
  fxAutoconfig = import ./fx-autoconfig.nix { inherit pkgs; };
  zenSrc = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
pkgs.stdenv.mkDerivation {
  pname = "zen";
  version = "1.0";

  buildPhase = ''
    mkdir -p $out
    cp -r ${zenSrc}/* $out/

    cp ${fxAutoconfig}/config.js $out/config.js
    mkdir -p $out/defaults/pref
    cp ${fxAutoconfig}/defaults/pref/config-prefs.js $out/defaults/pref/config-prefs.js

    mkdir -p $out/profile/chrome/JS
    cp -r ${sine}/JS/* $out/profile/chrome/JS/
  '';
}
