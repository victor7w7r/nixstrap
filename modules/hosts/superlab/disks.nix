{ disko, ... }:
{
  den.aspects.superlab.disks.nixos =
    let
      nvmepartitions.store = disko.xfs.call {
        name = "store";
        size = "100%";
        mountpoint = "/nix";
      };
      sdpartitions = {
        boot = disko.esp.call { size = "96M"; };
        persist = disko.f2fs.call {
          name = "persist";
          size = "100%";
          mountpoint = "/nix/persist";
          priority = 2;
        };
      };
    in
    {
      fileSystems = {
        "/nix/persist".neededForBoot = true;
        /*
          "/" = lib.mkDefault {
            device = "/dev/zram1";
            fsType = "ext4";
            neededForBoot = true;
            options = [
              "noatime"
              "x-systemd.device-timeout=0"
            ];
          };
        */
      };

      disko.devices.disk = {
        store = {
          type = "disk";
          device = "/dev/sda";
          content = {
            type = "gpt";
            partitions = nvmepartitions;
          };
        };

        sdcard = {
          type = "disk";
          device = "/dev/mmcblk0";
          content = {
            type = "gpt";
            partitions = sdpartitions;
          };
        };
      };
    };
}
/*
  fileSystems = {
  };
  "/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
    options = [
      "nofail"
      "noauto"
    ];
  };
  "/nix" = {
    device = "/dev/disk/by-label/store";
    neededForBoot = true;
    fsType = "xfs";
    options = [
      "noatime"
      "nodiratime"
      "lazytime"
      "logbufs=8"
      "logbsize=256k"
    ];
  };
  "/nix/persist" = f2fs {
    label = "persist";
    device = "/dev/disk/by-label/persist";
    depends = [ "/nix" ];
  };
  };
*/
