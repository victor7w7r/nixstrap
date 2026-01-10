{
  pkgs,
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation rec {
  pname = "updo";
  version = "latest";
  src = fetchurl {
    url = "https://github.com/Owloops/updo/releases/download/v0.4.5/updo_Linux_x86_64";
    sha256 = "sha256-6aZuKn1LpsEhX23V9O2Y08zbZM2SckAh3R5uI+0isKE=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/updo
    chmod +x $out/bin/updo
  '';

}
