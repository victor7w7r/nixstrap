{
  crane,
  inputs,
  pkgs,
}:
(crane {
  inherit pkgs;
  pname = "texoxide";
  src = inputs.texoxide;
})
