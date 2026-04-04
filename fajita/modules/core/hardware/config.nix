{ pkgs, lib, ... }:
{
  powerManagement.enable = true;

  hardware = {
    bluetooth.enable = true;
    enableAllFirmware = lib.mkForce false;
    enableRedistributableFirmware = lib.mkForce false;
    firmware = with pkgs; [ linux-firmware ];
  };
}
