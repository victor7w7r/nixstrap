{
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  pname = "texoxide";
  version = "latest";
  src = fetchurl {
    url = "https://github.com/arxari-archive/texoxide/releases/download/v1.0.2/texoxide-x86_64-unknown-linux-gnu";
    sha256 = "sha256-GDQlhkDQbirJTsp3mJJ0j62gjFPmLAO6GaxssxvfBMM=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/texoxide
    chmod +x $out/bin/texoxide
  '';
}
