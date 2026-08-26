{ disko, inputs, ... }:
{
  den.aspects.phone.disks.nixos = { pkgs, ... }: {
    fileSystems."/".autoResize = true;
    fileSystems."/tmp" = {
      device = "/nix/tmp";
      fsType = "none";
      options = [ "bind" ];
    };

    systemd.tmpfiles.rules = [ "d /nix/tmp 1777 root root -" ];

    imports = [ inputs.disko-mobile.nixosModules.disko ];

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
            device = "/dev/disk/by-partlabel/system_a";
            imageName = "nixos-boot";
            imageSize = "2G";
            content = esp.call {
              hasDefSectorSize = true;
              entireDisk = true;
            };
          };
          root = {
            type = "disk";
            device = "/dev/disk/by-partlabel/userdata";
            imageName = "nixos-root";
            imageSize = "48G";
            content = f2fs.call {
              hasDefSectorSize = true;
              entireDisk = true;
              mountpoint = "/nix";
            };
          };
        };
      };
    };
  };
}
