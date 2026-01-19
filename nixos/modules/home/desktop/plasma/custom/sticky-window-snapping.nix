{
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "sticky-window-snapping";
  version = "HEAD";

  src = fetchFromGitHub {
    owner = "Flupp";
    repo = "sticky-window-snapping";
    rev = "master";
    sha256 = "sha256-5xkKNgwzItnpdqk2z/HiCtXNm/ZyjXflSJcT1dAn6nU=";
  };

  installPhase = ''
    mkdir -p $out/share/kwin/scripts/sticky-window-snapping
    cp -r * $out/share/kwin/scripts/sticky-window-snapping/
  '';
}
