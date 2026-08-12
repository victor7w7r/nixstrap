{
  cache-stdenv,
  pkgs,
}:
cache-stdenv.mkDerivation {
  pname = "kf6-servicemenus-rootactions";
  version = "latest";
  src = pkgs.fetchurl {
    url = "https://gitlab.com/stefanwimmer128/kf6-servicemenus-rootactions/-/releases/v1.2.0/downloads/kf6-servicemenus-rootactions-v1.2.0.tar.xz";
    sha256 = "sha256-zhdIcjhc+axBO+sEYQ7rL1Hd2tMYCyCFKp0JqpMKRq8=";
  };
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
