{
  pkgs,
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation rec {
  pname = "carbonyl";
  version = "latest";
  src = fetchurl {
    url = "https://github.com/fathyb/carbonyl/releases/download/v0.0.3/carbonyl.linux-amd64.zip";
    sha256 = "sha256-6aZuKn1LpsEhX23V9O2Y08zbZM2SckAh3R5uI+0isKE=";
  };

  nativeBuildInputs = with pkgs; [ unzip ];
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    unzip $src -d $out/bin/
    chmod +x $out/bin/carbonyl
  '';

}
