{
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  pname = "progressline";
  version = "latest";
  src = fetchurl {
    url = "https://github.com/kattouf/ProgressLine/releases/download/0.2.4/progressline-0.2.4-aarch64-unknown-linux-gnu.zip";
    sha256 = "sha256-GDQlhkDQbirJTsp3mJJ0j62gjFPmLAO6GaxssxvfBMM=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    tar -xvf $src -C $out/bin
    chmod +x $out/bin/progressline
  '';
}
