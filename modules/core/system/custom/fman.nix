{
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  pname = "fman";
  version = "latest";
  src = fetchurl {
    url = "https://github.com/nore-dev/fman/releases/download/v1.20.1/fman_1.20.1_linux_amd64.tar.gz";
    sha256 = "sha256-Ww5sr1mloEHF3DAx8ae4ytdyDPByNbSnF/otqgzHBiY=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    tar -xvf $src -C $out/bin
    chmod +x $out/bin/fman
  '';
}
