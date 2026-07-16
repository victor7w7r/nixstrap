{ buildGoModule, inputs }:
buildGoModule {
  pname = "corrupter";
  version = "latest";
  src = inputs.corrupter;
  vendorHash = null;
}
