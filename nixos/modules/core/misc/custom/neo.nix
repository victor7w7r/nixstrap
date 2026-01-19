{
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  pname = "neo";
  version = "latest";
  src = fetchurl {
    url = "https://github.com/st3w/neo/releases/download/v0.6.1/neo-0.6.1.tar.gz";
    sha256 = "sha256-pV5O1e/QpK8kjRYBinqq07YX7x06wF0pKiWKOKr0ank=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    tar -xvf $src -C $out/bin
    chmod +x $out/bin/neo
  '';
}
