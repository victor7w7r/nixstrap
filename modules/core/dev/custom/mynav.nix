{
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  pname = "mynav";
  version = "latest";

  src = fetchurl {
    url = "https://github.com/GianlucaP106/mynav/releases/download/v2.2.0/mynav_Linux_x86_64.tar.gz";
    sha256 = "sha256-1B+T9UBjh9Pad+b0xNbVGGo/6tkiNz+ngfA+7KfQN24=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/mynav
    chmod +x $out/bin/mynav
  '';
}
