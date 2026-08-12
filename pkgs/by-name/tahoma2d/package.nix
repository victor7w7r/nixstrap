{ pkgs }:
pkgs.appimageTools.wrapType2 {
  pname = "tahoma2d";
  version = "latest";
  src = pkgs.stdenv.mkDerivation {
    name = "tahoma2d-source-appimage";
    src = pkgs.fetchurl {
      url = "https://github.com/tahoma2d/tahoma2d/releases/download/v1.6.1/Tahoma2D-linux-clang.tar.gz";
      sha256 = "sha256-+iufMYdZt3awTTxbLHb6WW1J/oHzmbV9kDzvDv+FhUs=";
    };
    installPhase = ''
      shopt -s globstar
      cp -r **/*.AppImage $out
    '';
  };

  extraPkgs =
    pkgs: with pkgs; [
      gtk3
      glib
    ];
}
