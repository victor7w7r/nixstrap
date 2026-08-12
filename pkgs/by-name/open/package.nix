{ pkgs, stdenvNoCC }:
stdenvNoCC.mkDerivation {
  pname = "open";
  version = "0.0.3";
  src = pkgs.fetchurl {
    url = "https://github.com/witt-bit/pc-guide/releases/download/v0.0.3/open.sh";
    sha256 = "sha256-2dCuAiWBeUX0yM+KN3Qc6IQibGuPZgZqVX8SLE08IwU=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/open
    chmod +x $out/bin/open
  '';
}
