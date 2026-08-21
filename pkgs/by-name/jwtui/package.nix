{
  rustBuild,
  inputs,
  pkgs,
}:
(rustBuild {
  inherit pkgs;
  pname = "jwt-ui";
  src = inputs.jwt-ui;
})
