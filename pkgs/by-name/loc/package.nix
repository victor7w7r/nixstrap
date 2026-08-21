{
  rustBuild,
  inputs,
  pkgs,
}:
(rustBuild {
  inherit pkgs;
  pname = "loc";
  cargoHash = "sha256-3ebajlV0ONO2ggMCtfwWLnOlGDi7dx1iL+FpyG8OSI0=";
  src = inputs.loc;
})
