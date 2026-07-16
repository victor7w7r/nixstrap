{ inputs, rustPlatform }:
rustPlatform.buildRustPackage {
  pname = "tuime";
  version = "latest";
  src = inputs.tuime;
  cargoHash = "sha256-3jqZ4x2ifvlFI7OcUye+pJ7wdPGcEo1z2PzcWR4xrkU=";
}
