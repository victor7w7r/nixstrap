{ cache-stdenv, inputs }:
cache-stdenv.mkDerivation {
  pname = "udefrag";
  version = "latest";
  src = pkgs.fetchurl {
    url = "https://web.archive.org/web/20220418235325/https://jp-andre.pagesperso-orange.fr/ultradefrag-5.0.0AB.8.zip";
    sha256 = "sha256-8QKdTLFFkJlMYFjhJAATgxC6K6gbrbho8i/9AijxkkY=";
  };
  prePatch = "patch -p 1 -i udefrag.patch";
  installPhase = ''
    mkdir -p $out/bin
    cp udefrag $out/bin
  '';
}
