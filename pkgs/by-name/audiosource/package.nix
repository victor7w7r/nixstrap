{ inputs, pkgs }:
pkgs.stdenvNoCC.mkDerivation {
  pname = "audiosource";
  version = "latest";
  src = inputs.audiosource;
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/audiosource
    chmod +x $out/bin/audiosource
  '';
}
