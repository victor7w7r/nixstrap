{
  crane,
  inputs,
  pkgs,
}:
(crane {
  inherit pkgs;
  pname = "envfetch";
  src = inputs.envfetch;
})
