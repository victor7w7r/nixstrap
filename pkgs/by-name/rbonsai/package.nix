{
  rustBuild,
  inputs,
  pkgs,
}:
(rustBuild {
  inherit pkgs;
  pname = "rbonsai";
  src = inputs.rbonsai;
  cargoHash = "sha256-78vOnu5RZgIR71x8fXbWmoeRDzRgaZBQXJ6nugLNij0=";
})
