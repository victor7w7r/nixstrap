{ inputs, rustPlatform }:
rustPlatform.buildRustPackage {
  pname = "ssh-list";
  version = "latest";
  src = inputs.ssh-list;
  cargoHash = "sha256-J4pBaZBqIbUYuMdwy6F5KNCfAZUWRvozvsPP2zl7aDc=";
}
