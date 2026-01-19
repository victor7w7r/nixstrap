{
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  pname = "treefetch";
  version = "latest";
  src = fetchurl {
    url = "https://github.com/angelofallars/treefetch/releases/download/v2.0.0/treefetch";
    sha256 = "sha256-GoNbr6dezS8YpTw+DXPPdCpXkQavA8TEWeX4yHPuUYc=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/treefetch
    chmod +x $out/bin/treefetch
  '';
}
