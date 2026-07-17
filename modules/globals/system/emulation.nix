{
  den.default.nixos =
    {
      isArm,
      isArmv7,
      isPersistent,
      isX86,
      lib,
      pkgs,
      ...
    }:
    {

      nixpkgs.overlays = [
        (_: prev: {
          libadwaita = prev.libadwaita.overrideAttrs (oldAttrs: {
            nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ pkgs.libxml2 ];
            preConfigure = ''
              export XMLLINT="${pkgs.libxml2}/bin/xmllint"
            '';
          });
        })
      ];

      boot.binfmt = lib.optionalAttrs isPersistent {
        preferStaticEmulators = true;
        emulatedSystems = [
          "x86_64-windows"
          "wasm64-wasi"
          "wasm32-wasi"
        ]
        ++ (lib.optionals isX86 [
          "i686-windows"
          "aarch64-linux"
          "armv7l-linux"
        ])
        ++ (lib.optionals (isArm || isArmv7) [ "x86_64-linux" ]);
        registrations = lib.mkMerge [
          (lib.mkIf isX86 {
            aarch64-linux = {
              interpreter = "${pkgs.pkgsStatic.qemu-user}/bin/qemu-aarch64";
              matchCredentials = true;
              wrapInterpreterInShell = false;
              preserveArgvZero = false;
              fixBinary = true;
            };

            armv7l-linux = {
              interpreter = "${pkgs.pkgsStatic.qemu-user}/bin/qemu-arm";
              magicOrExtension = ''\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28\x00'';
              mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\x00\xff\xfe\xff\xff\xff'';
            };

            /*
              windows = {
              interpreter = "${pkgs.wine}/bin/wine";
              offset = 0;
              magicOrExtension = "MZ";
              };
            */
          })

          (lib.mkIf (isArm || isArmv7) {
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
          })
          {
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
        ];
      };
    };
}
