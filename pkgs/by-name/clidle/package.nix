{ buildGoModule, inputs }:
buildGoModule {
  pname = "clidle";
  version = "latest";
  src = inputs.clidle;
  proxyVendor = true;
  vendorHash = "sha256-0adIVUKywNZBW8g4wdjJxa5JMMQdky3+PjHGU5L033g=";
  preBuild = ''export GOCACHE="/var/cache/gocache"'';
  doCheck = false;
  ldflags = [
    "-s"
    "-w"
  ];
  flags = [ "-trimpath" ];
}
