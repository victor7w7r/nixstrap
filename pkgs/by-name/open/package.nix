{ inputs, stdenvNoCC }:
stdenvNoCC.mkDerivation {
  pname = "open";
  version = "0.0.3";
  src = inputs.open;
  dontUnpack = true;
  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/open
    chmod +x $out/bin/open
  '';
}
