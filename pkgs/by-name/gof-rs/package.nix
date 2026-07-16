{ inputs, rustPlatform }:
rustPlatform.buildRustPackage {
  pname = "gof-rs";
  version = "latest";
  src = inputs.gof-rs;
  cargoHash = "sha256-yo6pKVGMPHipV5xXco/Kh0IHexWL7RKc1NslNk7qRzc=";
}
