{
  pkgs,
  stdenv,
  fetchFromGitHub,
  ...
}:
stdenv.mkDerivation rec {
  pname = "cliwrap";
  version = "HEAD";
  nativeBuildInputs = [ pkgs.pkg-config ];

  src = fetchFromGitHub {
    owner = "islemci";
    repo = pname;
    rev = version;
    sha256 = "sha256-NFBFZ4o5HG5iVFgkH2XOq7pc03vRXbScU2NFQwz3oiA=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp $src/cliwrap $out/bin/cliwrap
    chmod +x $out/bin/cliwrap
  '';

}
