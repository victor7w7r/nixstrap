{ pkgs, ... }:
{
  boot.binfmt = {
    registrations = {
      javascript-bun = {
        recognitionType = "extension";
        magicOrExtension = "js";
        interpreter = pkgs.writeShellScript "js-bun-wrapper" ''
          ${pkgs.bun}/bin/bun "$@"
        '';
      };
    };
    preferStaticEmulators = true;
    emulatedSystems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-windows"
      "i686-windows"
      "wasm32-wasi"
      "wasm64-wasi"
    ];
  };
}
