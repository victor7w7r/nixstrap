{ inputs, rustPlatform }:
rustPlatform.buildRustPackage {
  pname = "supdock";
  version = "latest";
  src = inputs.supdock;
  doCheck = false;
  cargoHash = "sha256-AAhfhSacdFrWEJg97hyzAbTxKTVkKhIXy4TKOClVOvs=";
}
