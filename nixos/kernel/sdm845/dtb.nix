{
  lib,
  pkgs,
  kernelData,
  device ? "fajita",
}:
let
  majorMinor = lib.versions.majorMinor kernelData.sdm845.version;
  fetch = (pkgs.callPackage ../fetch.nix { inherit kernelData majorMinor; });
in
pkgs.stdenv.mkDerivation {
  name = "dtb-sdm845";
  src = "${fetch.sdm845}/arch/arm64/boot/dts/qcom";

  nativeBuildInputs = [
    pkgs.dtc
    pkgs.gcc
  ];

  buildPhase = ''
    cpp -nostdinc -I . -I include -undef -x assembler-with-cpp sdm845-oneplus-${device}.dts > sdm845-oneplus-${device}.tmp.dts
    dtc -I dts -O dtb -o sdm845-oneplus-${device}.dtb sdm845-oneplus-${device}.tmp.dts
  '';

  installPhase = ''
    mkdir -p $out
    cp sdm845-oneplus-${device}.dtb $out/
  '';
}
