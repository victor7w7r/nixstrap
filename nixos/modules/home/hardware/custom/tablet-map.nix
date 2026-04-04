{
  pkgs,
  lib,
  fetchFromGitHub,
  rustPlatform,
  ...
}:
rustPlatform.buildRustPackage {
  pname = "tablet_map";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "victor7w7r";
    repo = "tablet_map";
    rev = "main";
    sha256 = "sha256-kA+LCoffX7+xnvi3xEweeP8a9uXimYU7trwM6zDMBhw=";
  };

  nativeBuildInputs = with pkgs; [
    stdenv.cc
    pkg-config
  ];

  cargoHash = "sha256-8aPasJIznPhBC4jrX+9rX81M9EyDjtmhaMd4NZKxQwc=";

  installPhase = ''
    mkdir -p $out/bin
    ls -lah ./target/x86_64-unknown-linux-gnu/release
    install -m755 -D target/x86_64-unknown-linux-gnu/release/tablet_map $out/bin/tablet_map
  '';
}
