{ buildGoModule, inputs }:
buildGoModule {
  pname = "pkgtop";
  version = "latest";
  src = inputs.pkgtop;
  vendorHash = "sha256-dlDbNym7CNn5088znMNgGAr2wBM3+nYv3q362353aLs=";
}
