{ disko, inputs, ... }:
{
  den.aspects.pizero.disks.nixos = with disko; {
    imports = [ inputs.disko.nixosModules.disko ];
    fileSystems = {
      "/etc".neededForBoot = true;
      "/nix/persist" = {
        device = "/dev/mapper/system";
        fsType = "f2fs";
        depends = [ "/nix" ];
        neededForBoot = true;
        options = (f2fs.args { highEnd = false; }).mountOptions;
      };
      "/home/victor7w7r/.cache" = {
        device = "/nix/victor7w7r/.cache";
        fsType = "none";
        neededForBoot = true;
        options = [ "bind" ];
      };
      "/root/.cache" = {
        device = "/nix/root/.cache";
        fsType = "none";
        neededForBoot = true;
        options = [ "bind" ];
      };
      "/var/cache" = {
        device = "/nix/var/cache";
        fsType = "none";
        neededForBoot = true;
        options = [ "bind" ];
      };
      "/var/tmp" = {
        device = "/nix/var/tmp";
        fsType = "none";
        options = [ "bind" ];
      };
      "/var/lib/docker" = {
        device = "/nix/var/lib/docker";
        fsType = "none";
        options = [ "bind" ];
      };
      "/tmp" = {
        device = "/nix/tmp";
        fsType = "none";
        options = [ "bind" ];
      };
    };
    boot.resumeDevice = "/dev/mapper/swapcrypt";
    systemd.tmpfiles.rules = [ "d /nix/tmp 1777 root root -" ];
    swapDevices = [
      {
        device = "/dev/mapper/swapcrypt";
        discardPolicy = "both";
        options = [ "nofail" ];
      }
    ];
    disko.devices = {
      disk = {
        root = disk.root { };
        main = disk.gpt {
          device = "mmcblk0";
          partitions = {
            esp = esp.call {
              size = "256M";
              name = "esp";
            };
            /*
              system = f2fs.call {
                name = "system";
                size = "100%";
                mountpoint = "/nix/persist";
                priority = 2;
              };
            */
          };
        };
        sda = disk.gpt {
          device = "sda";
          partitions = {
            /*
              swapcrypt = luks.call {
               name = "swapcrypt";
               size = "4G";
               content = swap.call { };
               priority = 6;
               };
            */
            system = btrfs.call {
              name = "system";
              priority = 2;
              size = "100%";
              subvolumes = btrfs.subvolumes {
                hasEtc = true;
                hasPersist = false;
              };
            };
          };
        };
      };
    };
  };
}
