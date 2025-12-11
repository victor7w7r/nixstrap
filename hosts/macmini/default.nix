{ modulesPath, lib, ... }:
with lib;
{
  options.setupDisks = mkOption {
    type = types.attrsOf types.str;
    description = "Rutas de los discos principales del sistema.";
    default = rec {
      maindevice = "/dev/nvme0n1";
      mockDisk = "/dev/mapper/vg0-fstemp";
      systemdisk = "/dev/mapper/vg0-system";
      homeDisk = "/dev/mapper/vg1-home";
      varDisk = "/dev/mapper/vg1-var";
      kvmDisk = "/dev/mapper/vg2-kvm";
      nvmeStorageDisk = "/dev/mapper/vg0-nvmestorage";
      docsDisk = "/dev/mapper/vg3-disk";
      extraFsck = ''
        if ! e2fsck -n ${kvmDisk}; then e2fsck -y ${kvmDisk}; fi
      '';
      extraDir = "media/nvmestorage media/docs";
      extraMount = ''
        mount -t btrfs -o noatime,lazytime,nodiscard,compress-force=zstd:3,commit=60 ${nvmeStorageDisk} /sysroot/media/nvmestorage
        mount -t btrfs -o noatime,lazytime,nodiscard,compress-force=zstd:3,commit=60 ${docsDisk} /sysroot/media/docs
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
