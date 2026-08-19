{ kernel, lib, ... }:
{
  kernel.lib = {

    cross-calc =
      pkgs: arch: system:
      if arch == "x86_64-linux" && system == "aarch64-linux" then
        pkgs.pkgsCross.aarch64-multiplatform
      else if arch == "aarch64-linux" && system == "x86_64-linux" then
        pkgs.pkgsCross.gnu64
      else
        pkgs;

    package-gen =
      pkgs: host: arch: system:
      (kernel.lib.cross-calc pkgs arch system)
      |> (recPkgs: kernel.hosts."${host}" recPkgs host arch)
      |> (src: {
        packages = lib.mkAfter {
          "${host}-config" = src."${host}-config";
          "${host}-allconfig" = src."${host}-allconfig";
          "${host}-kernel" = src."${host}-kernel";
          "${host}-kernelPackages" = src."${host}-kernelPackages";
        };

        devShells."${host}-menu-config" =
          (kernel.lib.cross-calc pkgs arch system)
          |> (
            recPkgs:
            recPkgs.mkShell {
              nativeBuildInputs =
                with recPkgs;
                src."${host}-kernel".nativeBuildInputs
                ++ [
                  ncurses
                  pkg-config
                  bison
                  flex
                ];

              shellHook = ''
                TMP_DIR="/tmp/kconfig-${src."${host}-kernel".name}"
                mkdir -p "$TMP_DIR"
                cd "$TMP_DIR"

                if [ ! -d "src" ]; then
                  if [ -d "${src."${host}-kernel".src}" ]; then
                    cp -r --no-preserve=mode,ownership "${src."${host}-kernel".src}" src
                  else
                    mkdir src
                    tar -xf "${src."${host}-kernel".src}" -C src --strip-components=1
                    chmod -R +w src
                  fi

                  chmod -R +rwx src
                  cd src

                  ${recPkgs.writeShellScript "patch-kernel.sh" ''
                    set -e
                    ${recPkgs.lib.concatMapStringsSep "\n" (p: ''
                      echo "Setting up: ${p.name or "patch"}"
                      patch -p1 < ${p.patch}
                    '') src."${host}-kernel".kernelPatches}
                  ''}
                else
                  cd src
                fi

                make ${recPkgs.lib.optionalString recPkgs.stdenv.hostPlatform.isAarch64 "ARCH=arm64"} defconfig
                make ${recPkgs.lib.optionalString recPkgs.stdenv.hostPlatform.isAarch64 "ARCH=arm64"} menuconfig
              '';
            }
          );
      });
  };
}
