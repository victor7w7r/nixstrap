{ inputs, rustPlatform }:
rustPlatform.buildRustPackage {
  pname = "loc";
  version = "latest";
  src = inputs.loc;
  cargoHash = "sha256-3ebajlV0ONO2ggMCtfwWLnOlGDi7dx1iL+FpyG8OSI0=";
}
