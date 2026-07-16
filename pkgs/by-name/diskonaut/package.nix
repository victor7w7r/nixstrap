{ inputs, rustPlatform }:
rustPlatform.buildRustPackage {
  pname = "diskonaut";
  version = "latest";
  src = inputs.diskonaut;
  doCheck = false;
  cargoLock.lockFile = "${inputs.diskonaut}/Cargo.lock";
  #  RUSTC_WRAPPER = "sccache";
  # SCCACHE_DIR = "/nix/var/cache/sccache";
}
