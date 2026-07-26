{ inputs, rustPlatform }:
rustPlatform.buildRustPackage {
  pname = "dprs";
  version = "latest";
  src = inputs.dprs;
  doCheck = false;
  cargoHash = "sha256-2NC4N4WZ2ype3MlqlvA/XSOvYkY0lQWlomvAqx11xQ4=";
}
