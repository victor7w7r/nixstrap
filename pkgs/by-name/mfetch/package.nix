{ inputs, rustPlatform }:
rustPlatform.buildRustPackage {
  pname = "mfetch";
  version = "latest";
  src = inputs.mfetch;
  cargoLock.lockFile = ./Cargo.lock;
  prePatch = "cp ${./Cargo.lock} Cargo.lock";
  cargoHash = "sha256-ywqXUp3X9Jf6O7OdWyyrUPaAJx+IAAvPQU+7nP2okpM=";
}
