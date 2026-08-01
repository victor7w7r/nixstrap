{
  crane,
  inputs,
  pkgs,
}:
(crane {
  inherit pkgs;
  pname = "treefetch";
  src = inputs.treefetch;
  nativeBuildInputs = with pkgs; [ pkg-config ];
})
