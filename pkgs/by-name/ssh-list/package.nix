{
  rustBuild,
  inputs,
  pkgs,
}:
(rustBuild {
  inherit pkgs;
  pname = "ssh-list";
  cargoHash = "sha256-J4pBaZBqIbUYuMdwy6F5KNCfAZUWRvozvsPP2zl7aDc=";
  src = inputs.ssh-list;
})
