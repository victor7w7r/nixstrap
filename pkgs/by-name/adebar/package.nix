{ inputs, stdenvNoCC }:
stdenvNoCC.mkDerivation {
  pname = "adebar";
  version = "latest";
  src = inputs.adebar;
  installPhase = ''
    mkdir -p $out/bin
    cp -r $src/* $out/bin/
  '';
}
