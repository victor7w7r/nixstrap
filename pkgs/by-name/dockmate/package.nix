{ buildGoModule, inputs }:
buildGoModule {
  pname = "dockmate";
  version = "latest";
  src = inputs.dockmate;
  vendorHash = "sha256-VkZAA6CBMzv3c6Byd3oq7IAokiQNtR/E8tIjBvozgd4=";
}
