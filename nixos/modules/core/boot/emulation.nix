{ system, pkgs, ... }:
{
  boot.binfmt = {
    preferStaticEmulators = true;
    emulatedSystems = [
      "x86_64-windows"
      "i686-windows"
      "wasm64-wasi"
      "wasm32-wasi"
    ]
    ++ (if system == "x86_64-linux" then [ "aarch64-linux" ] else [ "x86_64-linux" ]);
    registrations = {
      javascript-bun = {
        recognitionType = "extension";
        magicOrExtension = "js";
        interpreter = pkgs.writeShellScript "js-bun-wrapper" ''${pkgs.bun}/bin/bun "$@"'';
      };

      jar = {
        recognitionType = "extension";
        magicOrExtension = "jar";
        interpreter = pkgs.writeScript "binfmt-jar" ''
          #!/bin/sh
          exec ${pkgs.openjdk}/bin/java -jar "$@"
        '';
      };

      appimage = {
        wrapInterpreterInShell = false;
        interpreter = "${pkgs.appimage-run}/bin/appimage-run";
        recognitionType = "magic";
        offset = 0;
        mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
        magicOrExtension = ''\x7fELF....AI\x02'';
      };
    }
    // (
      if system == "x86_64-linux" then
        {
          aarch64-linux = {
            interpreter = "${pkgs.pkgsStatic.qemu-user}/bin/qemu-aarch64";
            matchCredentials = true;
            wrapInterpreterInShell = false;
            preserveArgvZero = false;
            fixBinary = true;
          };
          windows = {
            interpreter = "${pkgs.wine}/bin/wine";
            offset = 0;
            magicOrExtension = "MZ";
          };
        }
      else
        {
          FEX-x86_64 = {
            interpreter = "${pkgs.fex or "/usr/bin/FEXInterpreter"}/bin/FEXInterpreter";
            recognitionType = "magic";
            magicOrExtension = ''\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x3e\x00'';
            mask = ''\xff\xff\xff\xff\xff\xfe\xfe\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
            preserveArgvZero = true;
            fixBinary = true;
            wrapInterpreterInShell = false;
          };

          FEX-i386 = {
            interpreter = "${pkgs.fex or "/usr/bin/FEXInterpreter"}/bin/FEXInterpreter";
            recognitionType = "magic";
            magicOrExtension = ''\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x03\x00'';
            mask = ''\xff\xff\xff\xff\xff\xfe\xfe\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
            preserveArgvZero = true;
            fixBinary = true;
            wrapInterpreterInShell = false;
          };
        }
    );
  };
}
