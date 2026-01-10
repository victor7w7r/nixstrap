{
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  pname = "sxtetris";
  version = "latest";
  src = fetchurl {
    url = "https://github.com/shixinhuang99/sxtetris/releases/download/1.4.0/sxtetris-1.4.0-x86_64-unknown-linux-gnu.tar.gz";
    sha256 = "sha256-GDQlhkDQbirJTsp3mJJ0j62gjFPmLAO6GaxssxvfBMM=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    tar -xvf $src -C $out/bin
    chmod +x $out/bin/sxtetris
  '';
}
