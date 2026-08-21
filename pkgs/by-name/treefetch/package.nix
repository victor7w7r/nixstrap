{
  rustBuild,
  inputs,
  pkgs,
}:
(rustBuild {
  inherit pkgs;
  pname = "treefetch";
  src = inputs.treefetch;
  nativeBuildInputs = with pkgs; [ pkg-config ];
})
