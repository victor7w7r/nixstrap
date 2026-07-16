{ inputs, pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "kf6-servicemenus-rootactions";
  version = "latest";
  src = inputs.kf6-servicemenus-rootactions;
  nativeBuildInputs = with pkgs; [ cmake ];
  buildInputs = with pkgs; [
    kdePackages.dolphin
    kdePackages.kdialog
    imagemagick
    perl
    polkit
  ];
  dontWrapQtApps = true;
  configurePhase = "./configure --prefix=$out";
  buildPhase = "make";
  installPhase = "make install";
}
