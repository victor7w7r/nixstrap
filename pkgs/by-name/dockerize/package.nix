{ buildGoModule, inputs }:
buildGoModule {
  pname = "dockerize";
  version = "latest";
  src = inputs.dockerize;
  vendorHash = "sha256-/VM+CZSGTObAATsndqwp8btyw+uw2lhexx8NrvHazB4=";
}
