{
  crane,
  inputs,
  pkgs,
}:
(crane {
  inherit pkgs;
  pname = "kyun";
  src = inputs.kyun;
})
