{
  pkgs,
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
    sha256 = "sha256-vOJAYbB/ZcRxM+/lrkab/PcON3vOz3o6eqPvM9hmaOw=";
  };

  nativeBuildInputs = with pkgs; [
    stdenv.cc
    pkg-config
  ];

  cargoHash = "sha256-FKQYiaOTZxD95AWD2zbVjENzMAPrFl/rzhwbkAgGbx0=";

  installPhase = ''
    mkdir -p $out/bin
    install -m755 target/debug/tablet_map $out/bin/tablet_map
  '';
}
