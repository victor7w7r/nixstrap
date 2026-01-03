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
    sha256 = "sha256-zC096vsVCyDAEFpASU2gj0qRgWKYR1m9G6hPZL+61Wo=";
  };

  installPhase = ''
    mkdir -p $out/share/kwin/scripts/sticky-window-snapping
    cp -r * $out/share/kwin/scripts/sticky-window-snapping/
  '';
}
