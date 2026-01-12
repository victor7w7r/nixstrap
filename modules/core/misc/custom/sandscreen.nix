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
    sha256 = "sha256-aBj9ya1u3SnI0u0pxEkk+GYlyvbA8lVU1chxBaORLEs=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/sandscreen
    chmod +x $out/bin/sandscreen
  '';
}
