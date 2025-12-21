{
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "kMenu";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "51n7";
    repo = "kMenu";
    rev = "HEAD";
    sha256 = "sha256-Y7s9qdJIJbUqEP0/6qlTPOtE3efRqL1bx66MJIPgRN4=";
  };

  installPhase = ''
    mkdir -p $out/share/plasma/plasmoids
    mv package $out/share/plasma/plasmoids/org.51n7.kMenu
  '';
}
