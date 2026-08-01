{
  crane,
  inputs,
  pkgs,
}:
(crane {
  inherit pkgs;
  pname = "rbonsai";
  src = inputs.rbonsai;
})
