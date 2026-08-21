{
  rustBuild,
  inputs,
  pkgs,
}:
(rustBuild {
  inherit pkgs;
  pname = "rbonsai";
  src = inputs.rbonsai;
})
