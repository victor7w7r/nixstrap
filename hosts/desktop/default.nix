{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disks.nix
    ./../../modules/core
  ];

  powerManagement.cpuFreqGovernor = "ondemand";
}