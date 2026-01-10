{
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  pname = "cowsay";
  version = "latest";
  src = fetchurl {
    url = "https://github.com/Toni500github/cowsay/releases/download/v2.0.0-beta1/cowsay-linux-v2.0.0-beta1.tar.gz";
    sha256 = "sha256-GDQlhkDQbirJTsp3mJJ0j62gjFPmLAO6GaxssxvfBMM=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    tar -xvf $src -C $out/bin
    chmod +x $out/bin/cowsay
    chmod +x $out/bin/cowthink
  '';
}
