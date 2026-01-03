{
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "maxwell";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "wilversings";
    repo = "maxwell";
    rev = "HEAD";
    sha256 = "sha256-rDjfiZ7PEioh8xS2jWNRDIVhOWNiIm2ft6tNX5ZkeT4=";
  };

  installPhase = ''
    mkdir -p $out/share/plasma/plasmoids/maxwell
    mv * $out/share/plasma/plasmoids/maxwell/
  '';
}
