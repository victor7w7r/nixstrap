{ inputs, stdenvNoCC }:
stdenvNoCC.mkDerivation {
  pname = "sunxi-firmware";
  version = "4050e02";
  src = inputs.sunxi;
  compressFirmware = false;
  dontFixup = true;
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/lib/firmware
    cp -r uwe5622/* $out/lib/firmware/
  '';
}
