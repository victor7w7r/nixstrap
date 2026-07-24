{ inputs, sdcard, ... }:
{
  imports = [ (inputs.den.namespace "sdcard" false) ];

  sdcard.lib.call =
    {
      bootSize ? 256,
      isHDD ? true,
      nextPartSize ? 16384,
      isExtlinux ? true,
      isEntireDisk ? false,
      nextPartName ? "system",
      persistLabel ? "system",
      storeLabel ? "system",
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
          system.build.sdImage = pkgs.stdenv.mkDerivation {
            name =
              "nixos-image-${config.system.nixos.label}-" + "${host.name}-${pkgs.stdenv.hostPlatform.system}";
            nativeBuildInputs = with pkgs; [
              btrfs-progs
              dosfstools
              gptfdisk
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
                ${(image pkgs bootSize nextPartSize nextPartName isEntireDisk)}
                ${
                  (firmware (
                    lib.optionalString isExtlinux ''
                      mkdir -p firmware/boot
                      ${config.boot.loader.generic-extlinux-compatible.populateCmd} \
                        -c ${config.system.build.toplevel} -d firmware/boot
                    ''
                  ))
                }
                ${lib.optionalString (!isEntireDisk) (persist persistLabel)}
                ${(store closureInfo isHDD storeLabel isEntireDisk)}
                ${lib.optionalString (
                  !isEntireDisk
                ) "zstd -T$NIX_BUILD_CORES --rm boot.img && cp -a ./boot.img.zst $out/"}
              '');
          };
        };
    };
}
