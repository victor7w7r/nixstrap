{
  crane,
  inputs,
  pkgs,
}:
(crane {
  inherit pkgs;
  pname = "jwt-ui";
  src = inputs.jwt-ui;
})
