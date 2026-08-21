{
  rustBuild,
  inputs,
  pkgs,
}:
(rustBuild {
  inherit pkgs;
  pname = "jwt-ui";
  src = inputs.jwt-ui;
  cargoHash = "sha256-ywqXUp3X9Jf6O7OdWyyrUPaAJx+I3cvPQU+7nP2okpM=";
})
