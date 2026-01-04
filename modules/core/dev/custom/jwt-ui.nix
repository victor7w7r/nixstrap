{
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  pname = "jwt-ui";
  version = "latest";

  src = fetchurl {
    url = "https://github.com/jwt-rs/jwt-ui/releases/download/v1.3.0/jwtui-linux.tar.gz";
    sha256 = "sha256-1B+T9UBjh9Pad+b0xNbVGGo/6tkiNz+ngfA+7KfQN24=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/jwtui
    chmod +x $out/bin/jwtui
  '';
}
