{ buildGoModule, inputs }:
buildGoModule {
  pname = "spotitube";
  version = "latest";
  src = inputs.spotitube;
  doCheck = false;
  vendorHash = "sha256-uxwU7mDCB8jcKWqkvGwGPboWCCA6PkCkgMnlyx4bI/s=";
}
