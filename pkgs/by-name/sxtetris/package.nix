{ inputs, pkgs }:
pkgs.rustPlatform.buildRustPackage {
  pname = "sxtetris";
  version = "latest";
  src = inputs.sxtetris;
  cargoHash = "sha256-Ntx1xWDP3U0A+0N5t92d7H+y6HiA32D54K1wbJucyoc=";
  buildInputs = with pkgs; [ alsa-lib ];
  nativeBuildInputs = with pkgs; [ pkg-config ];
}
