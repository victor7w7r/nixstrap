{ inputs, rustPlatform }:
rustPlatform.buildRustPackage {
  pname = "supdock";
  version = "latest";
  src = inputs.supdock;
  doCheck = false;
  cargoHash = "sha256-+/rpcgXYmYXcBKE0q/vZCH4bZOXfwM+/jCs0q3MDNDc=";
}
