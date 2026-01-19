{ pkgs, ... }:
let
  inherit (pkgs) rustPlatform fetchFromGitHub;
  pname = "hf";
  version = "0.5.1";
in
rustPlatform.buildRustPackage rec {
  inherit pname version;
  nativeBuildInputs = [ pkgs.pkg-config ];

  src = fetchFromGitHub {
    owner = "sorairolake";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-NFBFZ4o5HG5iVFgkH2XOq7pc03vRXbScU2NFQwz3oiA=";
  };

  cargoLock.lockFile = "${src}/Cargo.lock";
}
