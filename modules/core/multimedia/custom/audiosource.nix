{
  pkgs,
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation rec {
  pname = "audiosource";
  version = "latest";
  src = fetchurl {
    url = "https://github.com/gdzx/audiosource/releases/download/v1.4/audiosource";
    sha256 = "sha256-6aZuKn1LpsEhX23V9O2Y08zbZM2SckAh3R5uI+0isKE=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src/audiosource $out/bin/audiosource
    chmod +x $out/bin/audiosource
  '';

}
