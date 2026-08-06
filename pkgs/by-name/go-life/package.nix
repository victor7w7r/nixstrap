{ buildGoModule, inputs }:
buildGoModule {
  pname = "go-life";
  version = "latest";
  src = inputs.go-life;
  vendorHash = "sha256-/VM+CZSGTObZGTsndqwp8btyw+uw2lhexx8NrvHazB4=";
  preBuild = ''export GOCACHE="/var/cache/gocache"'';
  doCheck = false;
  ldflags = [
    "-s"
    "-w"
  ];
  flags = [ "-trimpath" ];
}
