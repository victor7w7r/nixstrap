{
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  pname = "audio-share";
  version = "latest";
  src = fetchurl {
    url = "https://github.com/mkckr0/audio-share/releases/download/v0.3.4/audio-share-server-cmd-linux.tar.gz";
    sha256 = "sha256-6aZuKn1LpsEhX23V9O2Y08zbZM2SckAh3R5uI+0isKE=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    tar -xvf $src -C $out/bin
    chmod +x $out/bin/audio-share
  '';

}
