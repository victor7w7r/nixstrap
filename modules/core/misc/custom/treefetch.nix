{
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  pname = "treefetch";
  version = "latest";
  src = fetchurl {
    url = "https://github.com/angelofallars/treefetch/releases/download/v2.0.0/treefetch";
    sha256 = "sha256-GDQlhkDQbirJTsp3mJJ0j62gjFPmLAO6GaxssxvfBMM=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/treefetch
    chmod +x $out/bin/treefetch
  '';
}
