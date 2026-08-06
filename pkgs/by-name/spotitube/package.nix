{ buildGoModule, inputs }:
buildGoModule {
  pname = "spotitube";
  version = "latest";
  src = inputs.spotitube;
  vendorHash = "sha256-uxwU7mDCB8jcKWqkvGwGPboWCCA6PkCkgMnlyx4bI/s=";
  preBuild = ''export GOCACHE="/var/cache/gocache"'';
  doCheck = false;
  ldflags = [
    "-s"
    "-w"
  ];
  flags = [ "-trimpath" ];
}
