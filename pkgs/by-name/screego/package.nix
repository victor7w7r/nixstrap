{ buildGoModule, inputs }:
buildGoModule {
  pname = "screego";
  version = "latest";
  src = inputs.screego;
  vendorHash = "sha256-VkZSN6CBMzv3c6Byd3oq7IAokiQNtR/E8tIjBvozgd4=";
  preBuild = ''export GOCACHE="/var/cache/gocache"'';
  doCheck = false;
  ldflags = [
    "-s"
    "-w"
  ];
  flags = [ "-trimpath" ];
}
