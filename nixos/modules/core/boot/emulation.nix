{ ... }:
{
  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "i686-linux"
    "wasm32-wasi"
    "wasm64-wasi"
  ];
}
