{ pkgs, stdenv, ... }:
let
  inherit (pkgs) fetchFromGitHub;
  pname = "cfiles";
  version = "1.0.0";
in
stdenv.mkDerivation {
  inherit pname version;

  buildInputs = [ pkgs.glibc ];
  nativeBuildInputs = [ pkgs.pkg-config ];
  makeFlags = [ "PREFIX=$(out)" ];
  installPhase = "make install";

  src = fetchFromGitHub {
    owner = "FoleyBridge-Solutions";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-szDsxkkJRYnQ73iemi/DjArO3Z5kIAEoLoPkToHoRtM=";
  };
}
