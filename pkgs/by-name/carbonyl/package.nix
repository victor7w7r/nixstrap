{ pkgs }:
pkgs.stdenvNoCC.mkDerivation {
  pname = "carbonyl";
  version = "latest";
  src =
    if pkgs.stdenvNoCC.hostPlatform.isAarch64 then
      pkgs.fetchurl {
        url = "https://github.com/fathyb/carbonyl/releases/download/v0.0.3/carbonyl.linux-arm64.zip";
        sha256 = "sha256-W3XJkTjNq+RUk14sYJlK3OC9RXHxbk7s/fhnxZoRl74=";
      }
    else
      pkgs.fetchurl {
        url = "https://github.com/fathyb/carbonyl/releases/download/v0.0.3/carbonyl.linux-amd64.zip";
        sha256 = "sha256-RqkC6im7Mvdz+07jQUI3BbkjRagQQiuN+T6upqHsetI=";
      };

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
    mkdir -p $out/bin && cp $src/* $out/bin/
    chmod +x $out/bin/carbonyl
  '';
}
