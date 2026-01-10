{
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  pname = "termishare";
  version = "latest";
  src = fetchurl {
    url = "https://github.com/qnkhuat/termishare/releases/download/v0.0.4/termishare_0.0.4_Linux_x86_64.tar.gz";
    sha256 = "sha256-Ww5sr1mloEHF3DAx8ae4ytdyDPByNbSnF/otqgzHBiY=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    tar -xvf $src -C $out/bin
    chmod +x $out/bin/termishare
  '';
}
