{
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  pname = "envfetch";
  version = "latest";
  src = fetchurl {
    url = "https://github.com/ankddev/envfetch/releases/download/v2.1.2/envfetch-linux-amd64";
    sha256 = "sha256-GDQlhkDQbirJTsp3mJJ0j62gjFPmLAO6GaxssxvfBMM=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/envfetch
    chmod +x $out/bin/envfetch
  '';
}
