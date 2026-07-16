{ inputs, stdenvNoCC }:
stdenvNoCC.mkDerivation {
  pname = "nitronx";
  version = "latest";
  src = inputs.nitronx;
  dontUnpack = true;
  installPhase = ''
    mkdir -p $out/usr/bin
    mkdir -p $out/usr/include
    install -m 755 $src/nitrond $out/usr/bin/nitrond
    install -m 644 $src/nitronapi.sh $out/usr/include/nitronapi.sh
  '';
}
