{ inputs, rustPlatform }:
rustPlatform.buildRustPackage {
  pname = "t2fanrd";
  version = "0.9.0";
  src = inputs.t2fanrd;
  #nativeBuildInputs = with pkgs; [ sccache ];
  installPhase = ''
    install -m755 -D target/x86_64-unknown-linux-gnu/release/t2fanrd $out/bin/t2fanrd
  '';
  cargoHash = "sha256-FKQYiaOTZxD95AWD2zbVjENzMAPrFl/rzhwbkAgGbx0=";
  #RUSTC_WRAPPER = "sccache";
  #SCCACHE_DIR = "/nix/var/cache/sccache";
}
