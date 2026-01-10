{
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  pname = "sandscreen";
  version = "latest";
  src = fetchurl {
    url = "https://github.com/frostyarchtide/sandscreen/releases/download/v1.0.2/sandscreen";
    sha256 = "sha256-GDQlhkDQbirJTsp3mJJ0j62gjFPmLAO6GaxssxvfBMM=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/sandscreen
    chmod +x $out/bin/sandscreen
  '';
}
