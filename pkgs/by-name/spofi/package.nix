{ buildGoModule, inputs }:
buildGoModule {
  pname = "spofi";
  version = "latest";
  src = inputs.spofi;
  vendorHash = "sha256-1P4lj91WYNK5wE+c9AQsKhdJPgP3oBJjv2cw1mtJ528=";
  preBuild = ''export GOCACHE="/var/cache/gocache"'';
  doCheck = false;
  ldflags = [
    "-s"
    "-w"
  ];
  flags = [ "-trimpath" ];
}
