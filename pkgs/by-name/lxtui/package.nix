{ inputs, pkgs }:
pkgs.rustPlatform.buildRustPackage {
  pname = "lxtui";
  version = "latest";
  src = inputs.lxtui;
  buildInputs = with pkgs; [ openssl ];
  nativeBuildInputs = with pkgs; [ pkg-config ];
  cargoHash = "sha256-Rs9NQRlDv0Vt4NQGYs0jvFnlnlJ+wvgwBA4n1ZZ++io=";
}
