{ inputs, rustPlatform }:
rustPlatform.buildRustPackage {
  pname = "envfetch";
  version = "latest";
  src = inputs.envfetch;
  doCheck = false;
  cargoHash = "sha256-FPhfhSacdFrWEJg97hyzAbTxKTVkKhIXy4TKOClVOvs=";
}
