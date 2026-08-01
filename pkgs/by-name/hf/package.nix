{
  crane,
  inputs,
  pkgs,
}:
(crane {
  inherit pkgs;
  pname = "hf";
  src = inputs.hf;
})
