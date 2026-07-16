{ inputs, stdenvNoCC }:
stdenvNoCC.mkDerivation {
  pname = "uwe5622-firmware";
  version = "latest";
  src = inputs.sunxi;
  compressFirmware = false;
  dontFixup = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/lib/firmware
    cp -r uwe5622/* $out/lib/firmware/
  '';
}
