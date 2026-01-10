{
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  pname = "cli-of-life";
  version = "latest";
  src = fetchurl {
    url = "https://github.com/gabe565/cli-of-life/releases/download/v0.4.3/cli-of-life_0.4.3_linux_amd64.tar.gz";
    sha256 = "sha256-GDQlhkDQbirJTsp3mJJ0j62gjFPmLAO6GaxssxvfBMM=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    tar -xvf $src -C $out/bin
    chmod +x $out/bin/cli-of-life
  '';
}
