{ inputs, tarball, ... }:
{
  imports = [ (inputs.den.namespace "tarball" false) ];

  tarball.lib = {
    call =
      {
        additionalContent ? "",
        additionalBuildInputs ? [ ],
      }:
      {
        includes = [ tarball.lib.postscript ];

        nixos =
          { config, pkgs, ... }:
          {
            system.build.bootFiles = pkgs.stdenvNoCC.mkDerivation {
              name = "bootFiles";
              nativeBuildInputs = with pkgs; [ zstd ] ++ additionalBuildInputs;
              buildCommand = ''
                mkdir -p $out
                ${config.boot.loader.generic-extlinux-compatible.populateCmd} \
                  -c ${config.system.build.toplevel} -d firmware/boot
                mv firmware/boot ./boot
                tar -cv -C boot . | zstd -T$NIX_BUILD_CORES > $out/boot.tar.zst
              '';
            };

            system.build.initrd = pkgs.stdenvNoCC.mkDerivation {
              name = "genInitrd";
              buildCommand = ''
                cp "${config.system.build.initialRamdisk}/${config.system.boot.loader.initrdFile}" $out
              '';
            };

            system.build.tarball = pkgs.stdenvNoCC.mkDerivation {
              name = "tarball";

              nativeBuildInputs =
                with pkgs;
                [
                  zstd
                  rsyncy
                ]
                ++ additionalBuildInputs;

              buildCommand =
                (pkgs.buildPackages.closureInfo { rootPaths = [ config.system.build.toplevel ]; })
                |> (closureInfo: ''
                  mkdir -p $out

                  ${if additionalContent != "" then additionalContent else ""}

                  mkdir -p root/nix/store

                  echo "Copying store files..."
                  rsyncy -aHAxr --progress --files-from=${closureInfo}/store-paths / root/nix/

                  cp ${closureInfo}/registration root/nix-path-registration

                  mkdir -p root/nix/var/nix/daemon-socket
                  echo "Compressing with $SIZE..."
                  tar -cv -C root . | zstd -T$NIX_BUILD_CORES > $out/store.tar.zst
                '');
            };
          };
      };

    postscript.nixos =
      { config, ... }:
      {
        boot.postBootCommands = ''
          set -euo pipefail
          set -x

          REG_FILE="/nix/nix-path-registration"

          ${config.nix.package.out}/bin/nix-store --load-db < "$REG_FILE"
          touch /etc/NIXOS
          ${config.nix.package.out}/bin/nix-env -p /nix/var/nix/profiles/system --set /run/current-system
          rm -f "$REG_FILE"
        '';
      };
  };
}
