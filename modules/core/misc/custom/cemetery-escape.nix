{
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  pname = "cemetery-escape";
  version = "latest";
  src = fetchurl {
    url = "https://github.com/tom-on-the-internet/cemetery-escape/releases/download/0.0.7/cemetery-escape_0.0.7_linux_amd64.tar.gz";
    sha256 = "sha256-GDQlhkDQbirJTsp3mJJ0j62gjFPmLAO6GaxssxvfBMM=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    tar -xvf $src -C $out/bin
    chmod +x $out/bin/cemetery-escape
  '';
}
