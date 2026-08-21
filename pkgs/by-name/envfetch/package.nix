{
  rustBuild,
  inputs,
  pkgs,
}:
(rustBuild {
  inherit pkgs;
  cargoHash = "sha256-FPhfhSacdFrWEJg97hyzAbTxKTVkKhIXy4TKOClVOvs=";
  pname = "envfetch";
  src = inputs.envfetch;
})
