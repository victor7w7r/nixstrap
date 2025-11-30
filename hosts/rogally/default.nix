{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./env.nix
    ./../../modules/core
  ];

  powerManagement.cpuFreqGovernor = "ondemand";
}
