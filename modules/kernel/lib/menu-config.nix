{
  kernel.lib.menu-config =
    {
      kernel,
      pkgs,
      isArm ? false,
    }:
    pkgs.mkShell {
      nativeBuildInputs =
        with pkgs;
        kernel.nativeBuildInputs
        ++ [
          ncurses
          pkg-config
          bison
          flex
        ];

      shellHook = ''
        TMP_DIR="/tmp/kconfig-${kernel.name}"
        mkdir -p "$TMP_DIR"
        cd "$TMP_DIR"

        if [ ! -d "src" ]; then
          if [ -d "${kernel.src}" ]; then
            cp -r --no-preserve=mode,ownership "${kernel.src}" src
          else
            mkdir src
            tar -xf "${kernel.src}" -C src --strip-components=1
            chmod -R +w src
          fi

          chmod -R +rwx src
          cd src

          ${pkgs.writeShellScript "patch-kernel.sh" ''
            set -e
            ${pkgs.lib.concatMapStringsSep "\n" (p: ''
              echo "Setting up: ${p.name or "patch"}"
              patch -p1 < ${p.patch}
            '') kernel.kernelPatches}
          ''}
        else
          cd src
        fi

        make ${pkgs.lib.optionalString isArm "ARCH=arm64"} defconfig
        make ${pkgs.lib.optionalString isArm "ARCH=arm64"} menuconfig
      '';
    };
}
