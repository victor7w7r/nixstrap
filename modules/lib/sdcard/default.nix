{ inputs, sdcard, ... }:
{
  imports = [ (inputs.den.namespace "sdcard" false) ];

  sdcard.lib.call =
    {
      bootSize ? 256,
      isHDD ? true,
      nextPartSize ? 1024,
      isExtlinux ? true,
      useGpt ? false,
      isEntireDisk ? false,
      ubootSelector ? "",
      nextPartName ? "root",
      persistLabel ? "persist",
      postBuildCommands ? "",
      storeLabel ? "store",
    }:
    {
      includes = [ (sdcard.lib.postscript isHDD) ];

      nixos =
        {
          config,
          host,
          lib,
          pkgs,
          ...
        }:
        {
          system.nixos.tags = [ "sd-card" ];
          system.build.image = config.system.build.sdImage;
          system.build.bootFiles = (sdcard.lib.kernel pkgs ubootSelector postBuildCommands true);
          system.build.sdImage = pkgs.stdenv.mkDerivation {
            name =
              "nixos-image-${config.system.nixos.label}-" + "${host.name}-${pkgs.stdenv.hostPlatform.system}";
            nativeBuildInputs = with pkgs; [
              btrfs-progs
              dosfstools
              fakeroot
              f2fs-tools
              libfaketime
              mtools
              util-linux
              systemdUkify
              xfsprogs
              zstd
            ];

            buildCommand =
              with sdcard.lib;
              (pkgs.buildPackages.closureInfo { rootPaths = [ config.system.build.toplevel ]; })
              |> (closureInfo: ''

                ${(store closureInfo isHDD storeLabel isEntireDisk)}
              '');
          };
        };
    };
}
/*
  ${(image bootSize nextPartSize useGpt nextPartName isEntireDisk)}
  ${
    (firmware (
      lib.optionalString isExtlinux ''
        mkdir -p firmware/boot
        ${config.boot.loader.generic-extlinux-compatible.populateCmd} \
          -c ${config.system.build.toplevel} -d firmware/boot
      ''
    ))
  }
  ${lib.optionalString (!isEntireDisk) (persist nextPartSize persistLabel)}
  ${(kernel pkgs ubootSelector postBuildCommands isEntireDisk false)}
*/
