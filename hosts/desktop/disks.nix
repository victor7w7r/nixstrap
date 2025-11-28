{ lib, ... }:
{
  options.setupDisks = lib.mkOption {
    type = types.attrsOf types.str;
    description = "Rutas de los discos principales del sistema.";
    default = {
      maindevice = "/dev/vda1";
      mockdisk = "/dev/mapper/vg0-fstemp";
      systemdisk = "/dev/mapper/vg0-system";
      homedisk = "/dev/mapper/vg0-home";
      varDisk = "/dev/mapper/vg0-var";
    };
  };
}
