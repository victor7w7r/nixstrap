{
  rustBuild,
  inputs,
  pkgs,
}:
(rustBuild {
  inherit pkgs;
  pname = "treefetch";
  src = inputs.treefetch;
  cargoHash = "sha256-cbJ3Xr9oxMTfEtjcqeFL8c76p8bMMf3lbcdGU3cGvRA=";
  nativeBuildInputs = with pkgs; [ pkg-config ];
})
