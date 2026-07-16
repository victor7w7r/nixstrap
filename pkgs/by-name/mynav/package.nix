{ buildGoModule, inputs }:
buildGoModule {
  pname = "mynav";
  version = "latest";
  src = inputs.mynav;
  vendorHash = "sha256-EtPGBSW0deqRXO5iQjdgcySbvLSHa1gs25OBlImWWSM=";
}
