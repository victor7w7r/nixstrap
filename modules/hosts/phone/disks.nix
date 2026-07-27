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

      devices = with disko; {
        disk = {
          ephemeral-root = disk.root { };
          boot = {
            type = "disk";
            device = "/dev/disk/by-label/nixos-boot";
            imageName = "nixos-boot";
            imageSize = "2G";
            content = esp.call {
              hasDefSectorSize = true;
              entireDisk = true;
            };
          };
          root = {
            type = "disk";
            device = "/dev/disk/by-label/nixos-root";
            imageName = "nixos-root";
            imageSize = "4G";
            content = f2fs.call {
              entireDisk = true;
              mountpoint = "/nix";
            };
          };
        };
      };
    };
  };
}
