{
  rustBuild,
  inputs,
  pkgs,
}:
(rustBuild {
  inherit pkgs;
  pname = "zeitfetch";
  src = inputs.zeitfetch;
})
