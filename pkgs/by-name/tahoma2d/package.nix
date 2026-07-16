{ pkgs, inputs }:
pkgs.appimageTools.wrapType2 {
  pname = "tahoma2d";
  version = "latest";
  src = pkgs.stdenv.mkDerivation {
    name = "tahoma2d-source-appimage";
    src = inputs.tahoma2d;
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
