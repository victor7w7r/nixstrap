{
  rustBuild,
  inputs,
  pkgs,
}:
(rustBuild {
  inherit pkgs;
  pname = "cargofetch";
  nativeBuildInputs = with pkgs; [
    perl
    pkg-config
  ];
  cargoHash = "sha256-y+QcZHQf1tOq72MFJhLRf0ft5EyZZ+OXcG4g1TFkWfE=";
  buildInputs = with pkgs; [ openssl ];
  src = inputs.cargofetch;
})
