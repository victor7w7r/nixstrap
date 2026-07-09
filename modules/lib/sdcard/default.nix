{ inputs, sdcard, ... }:
{
  imports = [ (inputs.den.namespace "sdcard" false) ];

  sdcard.lib.call =
    {
      bootSize ? 96,
      isHDD ? true,
      persistSize ? 1024,
      isExtlinux ? true,
      ubootSelector ? "",
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
            name = "nixos-image-${config.system.nixos.label}-" + "${host}-${pkgs.stdenv.hostPlatform.system}";
            nativeBuildInputs = with pkgs; [
              bcachefs-tools
              dosfstools
              fakeroot
              f2fs-tools
              libfaketime
              mtools
              util-linux
              xfsprogs
              zstd
            ];

            buildCommand =
              with sdcard.lib;
              (pkgs.buildPackages.closureInfo { rootPaths = [ config.system.build.toplevel ]; })
              |> (closureInfo: ''
                mkdir -p $out

                ${lib.optionalString isExtlinux ''
                  mkdir -p firmware/boot
                  ${config.boot.loader.generic-extlinux-compatible.populateCmd} \
                    -c ${config.system.build.toplevel} -d firmware/boot
                ''}

                ${(persist persistSize persistLabel)}
                ${(boot bootSize persistSize)}
                dd conv=notrunc if=./persist.img of=boot.img seek=$START count=$SECTORS
                echo "Copying uboot and compressing kernel image..."

                ${(kernel pkgs ubootSelector postBuildCommands false)}
                ${(store closureInfo isHDD storeLabel)}
              '');
          };
        };
    };
}
