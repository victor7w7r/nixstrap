{ lib, modulesPath, ... }:
with lib;
{
  options.setupDisks = mkOption {
    type = types.attrsOf types.str;
    description = "Rutas de los discos principales del sistema.";
    default = rec {
      maindevice = "/dev/nvme0n1";
      mockDisk = "/dev/mapper/vg0-fstemp";
      systemDisk = "/dev/mapper/vg0-system";
      homeDisk = "";
      varDisk = "/dev/mapper/vg0-var";
      gameDisk = "/dev/disk/by-partlabel/disk-main-games";
      kvmDisk = "";
      extraFsck = "";
      extraDir = "games";
      extraMount = ''
        mount -t btrfs -o noatime,lazytime,nodiscard,compress-force=zstd:3,commit=60 ${gameDisk} /sysroot/games
      '';
    };
  };

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (import ./config.nix)
    (import ./../../modules/core)
    (import ./../../modules/home)
  ];
}
