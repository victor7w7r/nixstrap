{ inputs, pkgs }:
pkgs.rustPlatform.buildRustPackage {
  pname = "tablet_map";
  version = "latest";
  src = inputs.tablet-map;
  cargoHash = "sha256-8aPasJIznPhBC4jrX+9rX81M9EyDjtmhaMd4NZKxQwc=";
  installPhase = ''
    mkdir -p $out/bin
    ls -lah ./target/x86_64-unknown-linux-gnu/release
    install -m755 -D target/x86_64-unknown-linux-gnu/release/tablet_map $out/bin/tablet_map
  '';
  #RUSTC_WRAPPER = "sccache";
  #SCCACHE_DIR = "/nix/var/cache/sccache";
}
