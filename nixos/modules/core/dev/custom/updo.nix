{
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  pname = "updo";
  version = "latest";

  src = fetchurl {
    url = "https://github.com/Owloops/updo/releases/download/v0.4.5/updo_Linux_x86_64";
    sha256 = "sha256-1B+T9UBjh9Pad+b0xNbVGGo/6tkiNz+ngfA+7KfQN24=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/updo
    chmod +x $out/bin/updo
  '';
}
