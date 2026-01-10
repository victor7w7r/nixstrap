{
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  pname = "gspot";
  version = "latest";
  src = fetchurl {
    url = "https://github.com/abs3ntdev/gspot/releases/download/v0.0.35/gspot_Linux_x86_64.tar.gz";
    sha256 = "sha256-Ww5sr1mloEHF3DAx8ae4ytdyDPByNbSnF/otqgzHBiY=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    tar -xvf $src -C $out/bin
    chmod +x $out/bin/gspot
  '';
}
