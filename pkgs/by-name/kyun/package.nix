{ inputs, rustPlatform }:
rustPlatform.buildRustPackage {
  pname = "kyun";
  version = "latest";
  src = inputs.kyun;
  cargoHash = "sha256-Mqv3iPdbC1UElVtQynBeEaZfNJaIr2sFs3IYCB/SQ/c=";
}
