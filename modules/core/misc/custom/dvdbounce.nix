{
  pkgs,
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  pname = "dvdbounce";
  version = "0.0.41";
  src = fetchurl {
    url = "https://github.com/George-lewis/DVDBounce/releases/download/v1.31/Linux-Release-v1.31-x64.zip";
    sha256 = "sha256-4WM1ABAFvsCt987uN2HsOdDLO5LS+pWG+0CzlRuGQb4=";
  };

  nativeBuildInputs = with pkgs; [ unzip ];
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    unzip $src -d $out/bin/
    chmod +x $out/bin/dvdbounce
  '';
}
