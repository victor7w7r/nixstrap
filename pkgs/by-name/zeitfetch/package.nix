{ inputs, rustPlatform }:
rustPlatform.buildRustPackage {
  pname = "zeitfetch";
  version = "latest";
  src = inputs.zeitfetch;
  cargoHash = "sha256-GM3hY3KY/G1B/ashmjusbnT1tqcP6CdyHyGnaXTskcw=";
}
