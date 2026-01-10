{
  pkgs,
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation rec {
  pname = "aim";
  version = "latest";
  src = fetchurl {
    url = "https://github.com/mihaigalos/aim/releases/download/1.8.6/aim-1.8.6-x86_64-unknown-linux-gnu.tar.gz";
    sha256 = "sha256-6aZuKn1LpsEhX23V9O2Y08zbZM2SckAh3R5uI+0isKE=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    tar -xvf $src -C $out/bin
    chmod +x $out/bin/aim
  '';

}
