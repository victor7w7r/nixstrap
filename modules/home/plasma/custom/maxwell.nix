{
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "kMenu";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "wilversings";
    repo = "maxwell";
    rev = "HEAD";
    sha256 = "sha256-XKf3fBpx19J888XuufmmoDH7oz1H+fYCTW4yZ6Zjqvs=";
  };

  installPhase = ''
    mkdir -p $out/share/plasma/plasmoids
    mv . $out/share/plasma/plasmoids/maxwell
  '';
}
