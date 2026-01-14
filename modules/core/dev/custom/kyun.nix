{
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  pname = "kyun";
  version = "latest";
  src = fetchurl {
    url = "https://github.com/lennart-finke/kyun/releases/download/v0.02/kyun";
    sha256 = "sha256-saj7fm8vClf0hzxJL9npSus9D4vDwdCGrPrt6b2iXe0=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/kyun
    chmod +x $out/bin/kyun
  '';
}
