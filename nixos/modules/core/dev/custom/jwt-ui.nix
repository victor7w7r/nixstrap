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
    sha256 = "sha256-5FZhWACUI8ZrgoA/vKeV2VTAB199vcuf9D6Cv3W2dEs=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    tar -xvf $src -C $out/bin
    chmod +x $out/bin/jwtui
  '';
}
