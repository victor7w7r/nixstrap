{
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  pname = "fman";
  version = "latest";
  src = fetchurl {
    url = "https://github.com/nore-dev/fman/releases/download/v1.20.1/fman_1.20.1_linux_amd64.tar.gz";
    sha256 = "sha256-GDQlhkDQbirJTsp3mJJ0j62gjFPmLAO6GaxssxvfBMM=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    tar -xvf $src -C $out/bin
    chmod +x $out/bin/fman
  '';
}
