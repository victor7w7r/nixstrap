{ buildGoModule, inputs }:
buildGoModule {
  pname = "corrupter";
  version = "latest";
  src = inputs.corrupter;
  vendorHash = null;
  preBuild = ''export GOCACHE="/var/cache/gocache"'';
  doCheck = false;
  ldflags = [
    "-s"
    "-w"
  ];
  flags = [ "-trimpath" ];
}
