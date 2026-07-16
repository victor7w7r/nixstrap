{ buildGoModule, inputs }:
buildGoModule {
  pname = "go-life";
  version = "latest";
  src = inputs.go-life;
  vendorHash = "sha256-/VM+CZSGTObZGTsndqwp8btyw+uw2lhexx8NrvHazB4=";
}
