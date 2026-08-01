{ cache-stdenv, inputs }:
cache-stdenv.mkDerivation {
  pname = "udefrag";
  version = "latest";
  src = inputs.udefrag;
  prePatch = "patch -p 1 -i udefrag.patch";
  installPhase = ''
    mkdir -p $out/bin
    cp udefrag $out/bin
  '';
}
