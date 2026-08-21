{
  rustBuild,
  inputs,
  pkgs,
}:
(rustBuild {
  inherit pkgs;
  pname = "gof-rs";
  src = inputs.gof-rs;
})
