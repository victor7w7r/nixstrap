{ inputs, rustPlatform }:
rustPlatform.buildRustPackage {
  pname = "texoxide";
  version = "latest";
  src = inputs.texoxide;
  cargoHash = "sha256-aM1wQbKZsYb644rDqg6cnFwcigT/xU4in+YzDLf2K5o=";
}
