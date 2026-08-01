{
  crane,
  inputs,
  pkgs,
}:
(crane {
  inherit pkgs;
  pname = "tuime";
  src = inputs.tuime;
})
