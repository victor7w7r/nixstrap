{ buildGoModule, inputs }:
buildGoModule {
  pname = "cli-of-life";
  version = "latest";
  src = inputs.cli-of-life;
  vendorHash = "sha256-ZueGOJ7UoeixttPP/eTzChBtCDeySQw70CdBHv5zYgo=";
}
