{ inputs, rustPlatform }:
rustPlatform.buildRustPackage (attrs: {
  pname = "rbonsai";
  version = "latest";
  src = inputs.rbonsai;
  cargoHash = "sha256-78vOnu5RZgIR71x8fXbWmoeRDzRgaZBQXJ6nugLNij0=";
})
