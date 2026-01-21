{ ... }:
{
  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "armv7l-linux"
    "i686-linux"
    "wasm32-wasi"
    "wasm64-wasi"
  ];
}
