{ pkgs, ... }:
pkgs.stdenv.mkDerivation rec {
  pname = "fx-autoconfig";
  version = "1.0";

  src = pkgs.fetchFromGitHub {
    owner = "MrOtherGuy";
    repo = "fx-autoconfig";
    rev = "master";
    sha256 = "0000000000000000000000000000000000000000000000000000";
  };

  buildPhase = ''
    mkdir -p $out/defaults/pref
    mkdir -p $out/chrome

    cp ${src}/program/config.js $out/config.js
    cp ${src}/program/defaults/pref/config-prefs.js $out/defaults/pref/config-prefs.js
    cp -r ${src}/profile/chrome/* $out/chrome/
  '';
}
