{ buildGoModule, inputs }:
buildGoModule {
  pname = "dvdts";
  version = "latest";
  src = inputs.dvdts;
  vendorHash = "sha256-zEuzEGx8CVk/EeW+DCOg3C8k/SK0V3dnVdEpeFp422w=";
}
