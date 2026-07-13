{ inputs, pkgs }:
pkgs.rustPlatform.buildRustPackage {
  pname = "cargofetch";
  version = "latest";
  src = inputs.cargofetch;
  cargoHash = "sha256-y+QcZHQf1tOq72MFJhLRf0ft5EyZZ+OXcG4g1TFkWfE=";
  nativeBuildInputs = with pkgs; [ pkg-config ];
  buildInputs = with pkgs; [ openssl ];
}
