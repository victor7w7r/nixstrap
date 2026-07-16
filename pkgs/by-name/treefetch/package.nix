{ inputs, pkgs }:
pkgs.rustPlatform.buildRustPackage {
  pname = "treefetch";
  version = "latest";
  src = inputs.treefetch;
  cargoHash = "sha256-cbJ3Xr9oxMTfEtjcqeFL8c76p8bMMf3lbcdGU3cGvRA=";
  nativeBuildInputs = with pkgs; [ pkg-config ];
}
