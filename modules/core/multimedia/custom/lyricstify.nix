{
  pkgs,
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  pname = "lyricstify";
  version = "latest";
  src = fetchurl {
    url = "https://github.com/lyricstify/lyricstify/releases/download/v1.1.2/lyricstify-linux";
    sha256 = "sha256-6aZuKn1LpsEhX23V9O2Y08zbZM2SckAh3R5uI+0isKE=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    unzip $src -d $out/bin/
    chmod +x $out/bin/lyricstify
  '';
}
