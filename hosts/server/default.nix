{ lib, modulesPath, ... }:
with lib;
{
  options.setupDisks = mkOption {
    type = types.attrsOf types.str;
    description = "Rutas de los discos principales del sistema.";
    default = rec {
      maindevice = "/dev/nvme0n1";
      mockdisk = "/dev/mapper/vg0-fstemp";
      systemdisk = "/dev/mapper/vg0-system";
      homedisk = "/dev/mapper/vg0-home";
      varDisk = "/dev/mapper/vg0-var";
      kvmDisk = "/dev/mapper/vg0-kvm";
      extraFsck = ''
        if ! e2fsck -n ${kvmDisk}; then e2fsck -y ${kvmDisk}; fi
      '';
      extraDir = "";
      extraMount = "";
    };
  };

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (import ./config.nix)
    (import ./../../modules/core)
    (import ./../../modules/home)
    (import ./xserver.nix)
  ];
}
