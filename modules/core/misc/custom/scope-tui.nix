{
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  pname = "scope-tui";
  version = "latest";
  src = fetchurl {
    url = "https://github.com/alemidev/scope-tui/releases/download/v0.3.4/scope-tui-v0.3.4-linux-x64-gnu";
    sha256 = "sha256-GDQlhkDQbirJTsp3mJJ0j62gjFPmLAO6GaxssxvfBMM=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/
    chmod +x $out/bin/scope-tui
  '';
}
