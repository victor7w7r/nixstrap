{ inputs, rustPlatform }:
rustPlatform.buildRustPackage {
  pname = "autoricer";
  version = "main";
  src = inputs.autoricer;
  cargoLock.lockFile = ./Cargo.lock;
  prePatch = "cp ${./Cargo.lock} Cargo.lock";
  cargoHash = "sha256-ywqXUp3X9JfAAAOdWyyrUPaAJx+I3cvPQU+7nP2okpM=";
}
