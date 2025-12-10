{ lib, modulesPath, ... }:
with lib;
{
  options.setupDisks = mkOption {
    type = types.attrsOf types.str;
    description = "Rutas de los discos principales del sistema.";
    default = {
      maindevice = "/dev/vda";
      mockdisk = "/dev/mapper/vg0-fstemp";
      systemdisk = "/dev/mapper/vg0-system";
      homedisk = "/dev/mapper/vg0-home";
      varDisk = "/dev/mapper/vg0-var";
      kvmDisk = "";
      extraDir = "";
      extraFsck = "";
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
