{ stdenvNoCC }:
stdenvNoCC.mkDerivation {
  name = "brcm-firmware";
  src = ./brcm.tar.gz;
  dontUnpack = true;
  installPhase = "mkdir -p $out/lib/firmware && tar -xvf $src -C $out/lib/firmware/";
}
