{ buildGoModule, inputs }:
buildGoModule {
  pname = "dockerfilegraph";
  version = "latest";
  src = inputs.dockerfilegraph;
  vendorHash = "sha256-mx6ymmo9+behRlLUfm3NiDY7utyM/ACV5XPaiph39w8=";
}
