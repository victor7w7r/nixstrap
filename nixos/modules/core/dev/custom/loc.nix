{
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  pname = "loc";
  version = "latest";
  src = fetchurl {
    url = "https://github.com/cgag/loc/releases/download/v0.3.4/loc-v0.3.4-x86_64-unknown-linux-gnu.tar.gz";
    sha256 = "sha256-GDQlhkDQbirJTsp3mJJ0j62gjFPmLAO6GaxssxvfBMM=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    tar -xvf $src -C $out/bin
    chmod +x $out/bin/loc
  '';
}
