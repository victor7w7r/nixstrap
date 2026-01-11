{
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  pname = "go-life";
  version = "latest";
  src = fetchurl {
    url = "https://github.com/sachaos/go-life/releases/download/v0.4.0/go-life_linux_amd64";
    sha256 = "sha256-XXWwMT1bC34CIdA+bNV/KMOmQEnAxg010Lvkut0MweQ=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/go-life
    chmod +x $out/bin/go-life
  '';
}
