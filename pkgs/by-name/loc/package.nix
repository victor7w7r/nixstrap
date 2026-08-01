{
  crane,
  inputs,
  pkgs,
}:
(crane {
  inherit pkgs;
  pname = "loc";
  src = inputs.loc;
})
