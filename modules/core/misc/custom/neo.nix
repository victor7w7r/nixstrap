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
    sha256 = "sha256-GDQlhkDQbirJTsp3mJJ0j62gjFPmLAO6GaxssxvfBMM=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    tar -xvf $src -C $out/bin
    chmod +x $out/bin/neo
  '';
}
