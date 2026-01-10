{
  pkgs,
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  pname = "discli";
  version = "latest";
  src = fetchurl {
    url = "https://github.com/wynwxst/DisCli/releases/download/Discli-1.0/DisCliNux";
    sha256 = "sha256-6aZuKn1LpsEhX23V9O2Y08zbZM2SckAh3R5uI+0isKE=";
  };

  nativeBuildInputs = with pkgs; [ unzip ];
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/discli
    chmod +x $out/bin/discli
  '';

}
