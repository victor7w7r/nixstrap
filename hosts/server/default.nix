{ ... }:
{
  imports = [
    ./hardware-configuration
    ./env
    ./../../modules/core
    ./system
  ];

  powerManagement.cpuFreqGovernor = "ondemand";
}
