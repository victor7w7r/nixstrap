{ inputs, stdenvNoCC }:
stdenvNoCC.mkDerivation {
  pname = "armbian-firmware";
  version = "latest";

  dontBuild = true;
  dontFixup = true;

  src = inputs.armbian-firmware;
  installPhase = ''
    mkdir -p $out/lib/firmware
    cp -a * $out/lib/firmware/
  '';
}
