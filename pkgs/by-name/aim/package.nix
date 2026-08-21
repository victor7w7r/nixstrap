{
  rustBuild,
  inputs,
  pkgs,
}:
(rustBuild {
  inherit pkgs;
  pname = "aim";
  nativeBuildInputs = with pkgs; [ perl ];
  buildInputs = with pkgs; [ openssl ];
  cargoHash = "sha256-MPZWb+O1SY/fqTRZZyM9n4ScnzLr0XFAU8a0plSO830=";
  src = inputs.aim;
})
