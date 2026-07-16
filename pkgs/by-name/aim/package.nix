{ inputs, pkgs }:
pkgs.rustPlatform.buildRustPackage {
  pname = "aim";
  version = "latest";
  src = inputs.aim;
  cargoHash = "sha256-MPZWb+O1SY/fqTRZZyM9n4ScnzLr0XFAU8a0plSO830=";
  doCheck = false;
  nativeBuildInputs = with pkgs; [ perl ];
  buildInputs = with pkgs; [ openssl ];
  #RUSTC_WRAPPER = "sccache";
  #SCCACHE_DIR = "/nix/var/cache/sccache";
}
