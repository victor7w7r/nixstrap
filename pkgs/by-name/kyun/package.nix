{
  rustBuild,
  inputs,
  pkgs,
}:
(rustBuild {
  inherit pkgs;
  pname = "kyun";
  src = inputs.kyun;
  cargoHash = "sha256-Mqv3iPdbC1UElVtQynBeEaZfNJaIr2sFs3IYCB/SQ/c=";
})
