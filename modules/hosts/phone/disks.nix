{ disko, ... }:
{
  den.aspects.phone.disks.nixos = { pkgs, ... }: {
    fileSystems."/".autoResize = true;

    disko = {
      imageBuilder = {
        imageFormat = "raw";
        kernelPackages = pkgs.linuxPackages;
        useVirtualDevices = false;
      };
      /*
         lib.optionalAttrs (cfg.imageBuildSystem != pkgs.stdenv.buildPlatform.system) {
        enableBinfmt = true;
        pkgs = realBuildPkgs;
        kernelPackages = realBuildPkgs.linuxPackages;
        };
      */

      devices = with disko; {
        disk = {
          boot = {
            type = "disk";
            device = "/dev/disk/by-label/nixos-boot";
            imageName = label;
            imageSize = "2G";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [
                "umask=0077"
                "discard"
              ];
              extraArgs = [
                "-n"
                label
                "-S"
                "4096"
              ];
            };
          };
          root = {
            type = "disk";
            device = "/dev/disk/by-label/nixos-root";
            imageName = "nixos-root";
            imageSize = "4G";
            content = {
              type = "btrfs";
              extraArgs = [
                "--label"
                label
                "--sectorsize"
                "4096"
              ];

              subvolumes = {
                "@root" = {
                  mountpoint = "/";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
                "@nix" = {
                  mountpoint = "/nix";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
              };
            };
          };
        };
      };
    };
  };
}
