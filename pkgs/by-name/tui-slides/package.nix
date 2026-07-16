{ inputs, rustPlatform }:
rustPlatform.buildRustPackage {
  pname = "tui-slides";
  version = "latest";
  src = inputs.tui-slides;
  env.NIX_CFLAGS_COMPILE = "-std=gnu89 -Wno-error=incompatible-pointer-types";
  cargoHash = "sha256-1kVGOyxIbQmZA2NGih6mN505RfKKEmDrlymAtsrcQLU=";
}
