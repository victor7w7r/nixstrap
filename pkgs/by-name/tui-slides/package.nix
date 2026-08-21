{
  rustBuild,
  inputs,
  pkgs,
}:
(rustBuild {
  inherit pkgs;
  pname = "tui-slides";
  src = inputs.tui-slides;
  cargoHash = "sha256-1kVGOyxIbQmZA2NGih6mN505RfKKEmDrlymAtsrcQLU=";
  nativeBuildInputs = with pkgs; [ pkg-config ];
})
