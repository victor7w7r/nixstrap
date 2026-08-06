{ buildGoModule, inputs }:
buildGoModule {
  pname = "mynav";
  version = "latest";
  src = inputs.mynav;
  vendorHash = "sha256-EtPGBSW0deqRXO5iQjdgcySbvLSHa1gs25OBlImWWSM=";
  preBuild = ''export GOCACHE="/var/cache/gocache"'';
  doCheck = false;
  ldflags = [
    "-s"
    "-w"
  ];
  flags = [ "-trimpath" ];
}
