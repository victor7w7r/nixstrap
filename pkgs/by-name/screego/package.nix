{ buildGoModule, inputs }:
buildGoModule {
  pname = "screego";
  version = "latest";
  src = inputs.screego;
  vendorHash = "sha256-VkZSN6CBMzv3c6Byd3oq7IAokiQNtR/E8tIjBvozgd4=";
}
