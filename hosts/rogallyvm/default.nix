{ lib, modulesPath, ... }:
with lib;
{
  options.setupDisks = mkOption {
    type = types.attrsOf types.str;
    description = "Rutas de los discos principales del sistema.";
    default = rec {
      maindevice = "/dev/sda";
      mockDisk = "/dev/mapper/vg0-fstemp";
      systemDisk = "/dev/mapper/vg0-system";
      homeDisk = "";
      varDisk = "/dev/mapper/vg0-var";
      kvmDisk = "";
      extraFsck = "";
      extraDir = "";
      extraMount = "";
    };
  };

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (import ./config.nix)
    (import ./../../modules/core)
    (import ./../../modules/home)
  ];
}
