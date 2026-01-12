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
    sha256 = "sha256-21KfKh/Lw6KP8NkjV6qn8rGQYMC9+4xwr2Azr+71EYk=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    tar -xvf $src -C $out/bin
    chmod +x $out/bin/sxtetris
  '';
}
