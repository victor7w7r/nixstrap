{ kernel, ... }:
{
  perSystem =
    { pkgs, lib, ... }:
    {
      devShells.kconfig = pkgs.mkShell {
        nativeBuildInputs = ((kernel.hosts.pizero pkgs).pizero-kernel).nativeBuildInputs ++ [
          pkgs.ncurses
          pkgs.pkg-config
          pkgs.bison
          pkgs.flex
        ];

        shellHook = ''
          echo "=== Preparando kernel parcheado para pizero ==="

          TMP_DIR="/tmp/kconfig-pizero"
          mkdir -p "$TMP_DIR"
          cd "$TMP_DIR"

          if [ ! -d "src" ]; then
            echo "--> Desempacando fuentes..."
            mkdir src
            tar -xf ${((kernel.hosts.pizero pkgs).pizero-kernel).src} -C src --strip-components=1
            chmod -R +w src
            cd src

            echo "--> Aplicando parches del kernel..."
            ${lib.concatMapStringsSep "\n" (p: ''
              echo "Aplicando: ${p.name or "parche"}"
              patch -p1 < ${p.patch}
            '') ((kernel.hosts.pizero pkgs).pizero-kernel).kernelPatches}
          else
            cd src
          fi

          echo "--> Abriendo menuconfig en ARM64..."
          make ARCH=arm64 defconfig
          make ARCH=arm64 menuconfig
        '';
      };
    };
}
