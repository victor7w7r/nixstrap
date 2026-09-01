{
  rustBuild,
  inputs,
  pkgs,
}:
(rustBuild {
  inherit pkgs;
  pname = "hf";
  cargoHash = "sha256-eA8HpD/XnYrTFz7ez3g9RndYg0LbjQD1DPitq2EsDCw=";
  src = inputs.hf;
})
