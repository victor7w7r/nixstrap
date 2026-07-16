{ inputs, pkgs }:
pkgs.stdenvNoCC.mkDerivation {
  pname = "progressline";
  version = "latest";
  nativeBuildInputs = with pkgs; [ unzip ];
  src =
    if pkgs.stdenvNoCC.hostPlatform.isAarch64 then
      inputs.progressline-arm64
    else
      inputs.progressline-amd64;
  dontUnpack = true;
  installPhase = ''
    mkdir -p $out/bin $out/temp
    cp -r $src/* $out/bin/
    ls $out/bin/
    chmod +x $out/bin/progressline
  '';
}
