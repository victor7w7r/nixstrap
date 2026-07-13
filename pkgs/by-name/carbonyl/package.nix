{ inputs, pkgs }:
pkgs.stdenvNoCC.mkDerivation {
  pname = "carbonyl";
  version = "latest";
  src =
    if pkgs.stdenvNoCC.hostPlatform.isAarch64 then inputs.carbonyl-arm64 else inputs.carbonyl-amd64;
  nativeBuildInputs = with pkgs; [
    autoPatchelfHook
    unzip
  ];
  buildInputs = with pkgs; [
    alsa-lib
    expat
    nss
    stdenv.cc.cc.lib
  ];
  installPhase = ''
    mkdir -p $out/bin
    cp $src/* $out/bin/
    chmod +x $out/bin/carbonyl
  '';
}
