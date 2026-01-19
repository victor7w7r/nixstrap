{
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  pname = "clidle";
  version = "latest";
  src = fetchurl {
    url = "https://github.com/ajeetdsouza/clidle/releases/download/v0.1.0/clidle_Linux_x86_64.tar.gz";
    sha256 = "sha256-eM2kyGhnR1UsY9so4uTXrHLJN1uEtloRyzwixqaVU1E=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    tar -xvf $src -C $out/bin
    chmod +x $out/bin/clidle
  '';
}
