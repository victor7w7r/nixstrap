{
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  pname = "paclear";
  version = "latest";
  src = fetchurl {
    url = "https://github.com/orangekame3/paclear/releases/download/v0.0.13/paclear_Linux_x86_64.tar.gz";
    sha256 = "sha256-GDQlhkDQbirJTsp3mJJ0j62gjFPmLAO6GaxssxvfBMM=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    tar -xvf $src -C $out/bin
    chmod +x $out/bin/paclear
  '';
}
