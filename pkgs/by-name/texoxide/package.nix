{
  rustBuild,
  inputs,
  pkgs,
}:
(rustBuild {
  inherit pkgs;
  pname = "texoxide";
  cargoHash = "sha256-aM1wQbKZsYb644rDqg6cnFwcigT/xU4in+YzDLf2K5o=";
  src = inputs.texoxide;
})
