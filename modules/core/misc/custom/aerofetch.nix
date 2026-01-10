{
  pkgs,
  stdenv,
  fetchFromGitHub,
  ...
}:

stdenv.mkDerivation rec {
  pname = "AeroFetch";
  version = "HEAD";
  nativeBuildInputs = [ pkgs.pkg-config ];

  src = fetchFromGitHub {
    owner = "driizzyy";
    repo = pname;
    rev = version;
    sha256 = "sha256-NFBFZ4o5HG5iVFgkH2XOq7pc03vRXbScU2NFQwz3oiA=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp $src/AeroFetch.sh $out/bin/aerofetch.sh
    chmod +x $out/bin/aerofetch.sh
  '';

}
