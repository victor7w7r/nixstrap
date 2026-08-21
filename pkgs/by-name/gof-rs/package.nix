{
  rustBuild,
  inputs,
  pkgs,
}:
(rustBuild {
  inherit pkgs;
  cargoHash = "sha256-yo6pKVGMPHipV5xXco/Kh0IHexWL7RKc1NslNk7qRzc=";
  pname = "gof-rs";
  src = inputs.gof-rs;
})
