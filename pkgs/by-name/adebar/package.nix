{ inputs, stdenvNoCC }:
stdenvNoCC.mkDerivation (attrs: {
  pname = "adebar";
  version = "latest";

  src = inputs.adebar;

  installPhase = ''
    mkdir -p $out/bin
    cp -r $src/* $out/bin/
  '';
})
