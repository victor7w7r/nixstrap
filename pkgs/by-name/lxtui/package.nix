{
  rustBuild,
  inputs,
  pkgs,
}:
(rustBuild {
  inherit pkgs;
  pname = "lxtui";
  buildInputs = with pkgs; [ openssl ];
  nativeBuildInputs = with pkgs; [ pkg-config ];
  cargoHash = "sha256-Rs9NQRlDv0Vt4NQGYs0jvFnlnlJ+wvgwBA4n1ZZ++io=";
  src = inputs.lxtui;
})
