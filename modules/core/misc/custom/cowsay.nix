{
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  pname = "cowsay";
  version = "latest";
  src = fetchurl {
    url = "https://github.com/Code-Hex/Neo-cowsay/releases/download/v2.0.4/cowsay_2.0.4_Linux_x86_64.tar.gz";
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
