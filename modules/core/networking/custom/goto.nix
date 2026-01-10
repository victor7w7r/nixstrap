{
  pkgs,
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation rec {
  pname = "goto";
  version = "latest";
  src = fetchurl {
    url = "https://github.com/grafviktor/goto/releases/download/v1.5.0/goto-v1.5.0.zip";
    sha256 = "sha256-6aZuKn1LpsEhX23V9O2Y08zbZM2SckAh3R5uI+0isKE=";
  };

  nativeBuildInputs = with pkgs; [ unzip ];
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    unzip $src -d $out/bin/
    chmod +x $out/bin/gg-lin
  '';

}
