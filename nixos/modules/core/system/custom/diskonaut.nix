{ pkgs, ... }:
let
  inherit (pkgs) rustPlatform fetchFromGitHub;
  pname = "diskonaut";
  version = "0.11.0";
in
rustPlatform.buildRustPackage rec {
  inherit pname version;
  nativeBuildInputs = [ pkgs.pkg-config ];

  src = fetchFromGitHub {
    owner = "imsnif";
    repo = pname;
    rev = version;
    sha256 = "sha256-pLQosVnAQZ82OUcR/wD8QnYs9JVJZ+HrB0NNkcdTq94=";
  };

  cargoLock.lockFile = "${src}/Cargo.lock";

}
