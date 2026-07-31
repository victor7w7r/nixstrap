{
  crane,
  inputs,
  pkgs,
}:
(crane {
  inherit pkgs;
  pname = "dprs";
  src = inputs.dprs;
})
