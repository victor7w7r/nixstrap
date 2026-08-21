{
  rustBuild,
  inputs,
  pkgs,
}:
(rustBuild {
  inherit pkgs;
  pname = "hwfetch";
  src = inputs.hwfetch;
  cargoHash = "sha256-v2IbR1caH+7/XeBmvvWQz47gV8YZMmGvA5RNoz+kXrI=";
})
