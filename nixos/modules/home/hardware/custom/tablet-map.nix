{
  fetchFromGitHub,
  rustPlatform,
  lib,
  ...
}:
rustPlatform.buildRustPackage {
  pname = "tablet_map";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "victor7w7r";
    repo = "tablet_map";
    rev = "main";
    sha256 = "sha256-vOJAYbB/ZcRxM+/lrkab/PcON3vOz3o6eqPvM9hmaOw=";
  };

  cargoHash = lib.fakeHash;

  installPhase = ''
    ls -R
    install -m755 -D target/x86_64-unknown-linux-gnu/release/tablet_map $out/bin/tablet_map
  '';
}
