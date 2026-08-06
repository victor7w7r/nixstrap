{ buildGoModule, inputs }:
buildGoModule {
  pname = "hypr-zoom";
  version = "latest";
  src = inputs.hypr-zoom;
  vendorHash = "sha256-BCx2hKi6U/MPJlwAmnM4/stiolhYkakpe4EN3e5r6L4=";
  preBuild = ''export GOCACHE="/var/cache/gocache"'';
  doCheck = false;
  ldflags = [
    "-s"
    "-w"
  ];
  flags = [ "-trimpath" ];
}
