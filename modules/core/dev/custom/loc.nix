{ pkgs, ... }:
let
  inherit (pkgs) rustPlatform fetchFromGitHub;
  pname = "loc";
  version = "0.4.1";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  nativeBuildInputs = [ pkgs.pkg-config ];

  src = fetchFromGitHub {
    owner = pname;
    repo = "loc";
    rev = "v${version}";
    sha256 = "1i9dlhw0xk1viglyhail9fb36v1awrypps8jmhrkz8k1bhx98ci3";
  };

  cargoHash = "sha256-Afr3ShCXDCwTQNdeCZbA5/aosRt+KFpGfT1mrob6cog=";
}
