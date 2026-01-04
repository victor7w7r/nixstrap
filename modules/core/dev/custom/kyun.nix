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
    sha256 = "sha256-1B+T9UBjh9Pad+b0xNbVGGo/6tkiNz+ngfA+7KfQN24=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/kyun
    chmod +x $out/bin/kyun
  '';
}
