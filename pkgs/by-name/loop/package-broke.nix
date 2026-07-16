{ inputs, pkgs }:
pkgs.rustPlatform.buildRustPackage {
  pname = "loop";
  version = "latest";
  src = inputs.loop;
  cargoHash = "sha256-sceS/2qxiV16VP8E3M39MYnGiCbq0rrnehsV/SuHZl4=";
}
