{
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  pname = "customfetch";
  version = "latest";
  src = fetchurl {
    url = "https://github.com/Toni500github/customfetch/releases/download/v2.0.0-beta1/customfetch-linux-v2.0.0-beta1.tar.gz";
    sha256 = "sha256-GDQlhkDQbirJTsp3mJJ0j62gjFPmLAO6GaxssxvfBMM=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    tar -xvf $src -C $out/bin
    chmod +x $out/bin/customfetch
  '';
}
