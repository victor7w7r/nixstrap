{ system, pkgs, ... }:
{
  /*
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
      "wasm64-wasi"
    ]
    ++ (
      if system == "aarch64-linux" then
        [ "x86_64-linux" ]
      else
        [
          "aarch64-linux"
          "x86_64-windows"
          "i686-windows"
        ]
    );
    };
  */
}
