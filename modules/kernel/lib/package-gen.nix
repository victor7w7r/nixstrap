{ kernel, lib, ... }:
{
  kernel.lib.package-gen =
    pkgs: host:
    (kernel.hosts."${host}" pkgs host)
    |> (src: {
      packages = lib.mkAfter {
        "${host}-config" = src."${host}-config";
        "${host}-allconfig" = src."${host}-allconfig";
        "${host}-kernel" = src."${host}-kernel";
        "${host}-kernelPackages" = src."${host}-kernelPackages";
      };

      devShells."${host}-menu-config" = pkgs.mkShell {
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
          TMP_DIR="/tmp/kconfig-${src.name}"
          mkdir -p "$TMP_DIR"
          cd "$TMP_DIR"

          if [ ! -d "src" ]; then
            if [ -d "${src.src}" ]; then
              cp -r --no-preserve=mode,ownership "${src.src}" src
            else
              mkdir src
              tar -xf "${src.src}" -C src --strip-components=1
              chmod -R +w src
            fi

            chmod -R +rwx src
            cd src

            ${pkgs.writeShellScript "patch-kernel.sh" ''
              set -e
              ${pkgs.lib.concatMapStringsSep "\n" (p: ''
                echo "Setting up: ${p.name or "patch"}"
                patch -p1 < ${p.patch}
              '') src.kernelPatches}
            ''}
          else
            cd src
          fi

          make ${pkgs.lib.optionalString pkgs.stdenv.hostPlatform.isAarch64 "ARCH=arm64"} defconfig
          make ${pkgs.lib.optionalString pkgs.stdenv.hostPlatform.isAarch64 "ARCH=arm64"} menuconfig
        '';
      };
    });
}
