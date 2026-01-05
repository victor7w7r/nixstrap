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
    sha256 = "sha256-1+0mH5l4UIrBGWBFo3F1EFL/PDzyLY/4A0D3MwBILSI=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    tar -xvf $src -C $out/bin
    chmod +x $out/bin/mynav
  '';
}
