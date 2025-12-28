{
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "virtual-desktops-only-on-primary";
  version = "v0.4.5";

  src = fetchFromGitHub {
    owner = "Ubiquitine";
    repo = "virtual-desktops-only-on-primary";
    rev = "master";
    sha256 = "sha256-zC096vsVCyDAEFpASU2gj0qRgWKYR1m9G6hPZL+61Wo=";
  };

  installPhase = ''
    mkdir -p $out/share/kwin/scripts/virtual-desktops-only-on-primary
    cp -r * $out/share/kwin/scripts/virtual-desktops-only-on-primary/
  '';
}
