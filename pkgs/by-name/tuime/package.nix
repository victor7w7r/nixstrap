{
  rustBuild,
  inputs,
  pkgs,
}:
(rustBuild {
  inherit pkgs;
  pname = "tuime";
  cargoHash = "sha256-3jqZ4x2ifvlFI7OcUye+pJ7wdPGcEo1z2PzcWR4xrkU=";
  src = inputs.tuime;
})
