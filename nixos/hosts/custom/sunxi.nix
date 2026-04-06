{
  stdenvNoCC,
  fetchFromGitHub,
  ...
}:
stdenvNoCC.mkDerivation {
  pname = "sunxi-firmware";
  version = "4050e02";

  compressFirmware = false;
  dontFixup = true;
  dontBuild = true;

  src = fetchFromGitHub {
    owner = "armbian";
    repo = "firmware";
    rev = "4050e02da2dce2b74c97101f7964ecfb962f5aec";
    sha256 = "sha256-wc4xyNtUlONntofWJm8/w0KErJzXKHijOyh9hAYTCoU=";
  };

  installPhase = ''
    mkdir -p $out/lib/firmware
    cp -r uwe5622/* $out/lib/firmware/
  '';
}
