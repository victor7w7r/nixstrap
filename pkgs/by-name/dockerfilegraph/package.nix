{ buildGoModule, inputs }:
buildGoModule {
  pname = "dockerfilegraph";
  version = "latest";
  src = inputs.dockerfilegraph;
  vendorHash = "sha256-7nQZekXDzs5VMTKGCcvfMx8nxeyGaPM1dPXGAjyz7Ck=";
}
