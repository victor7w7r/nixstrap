{ ... }:
{
  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "aarch64_be-linux"
    "armv6l-linux"
    "armv7l-linux"
    "i386-linux"
    "i486-linux"
    "i586-linux"
    "i686-linux"
    "i686-windows"
    "loongarch64-linux"
    "wasm32-wasi"
    "wasm64-wasi"
    "x86_64-windows"
  ];
}
