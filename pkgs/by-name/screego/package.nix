{ buildGoModule, inputs }:
buildGoModule {
  pname = "screego";
  version = "latest";
  src = inputs.screego;
  vendorHash = "sha256-/yOAAvbt+H7AQLXn2gp+6JRaLTDR3hBznOq5L1DUUUQ=";
}
