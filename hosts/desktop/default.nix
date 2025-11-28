{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/core
  ];

  setupDisks = {
    maindevice = "/dev/vda1";
    mockdisk = "/dev/mapper/vg0-fstemp";
    systemdisk = "/dev/mapper/vg0-system";
    homedisk = "/dev/mapper/vg0-home";
    varDisk = "/dev/mapper/vg0-var";
  };

  powerManagement.cpuFreqGovernor = "ondemand";
}