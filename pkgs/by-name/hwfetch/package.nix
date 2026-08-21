{
  rustBuild,
  inputs,
  pkgs,
}:
(rustBuild {
  inherit pkgs;
  pname = "hwfetch";
  src = inputs.hwfetch;
})
