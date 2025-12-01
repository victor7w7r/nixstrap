{ ... }:
{
  imports = [
    ./hardware-configuration
    ./env
    ./../../modules/core
  ];

  powerManagement.cpuFreqGovernor = "ondemand";
}
