{ pkgs, lib, ... }:
{
  environment.systemPackages =
    with pkgs;
    lib.mkAfter [
      cpulimit
      cyme
      dysk
      fan2go
      i2c-tools
      hwinfo
      lshw
      read-edid
      smartmontools
      usbutils
    ];

  programs.corectrl.enable = true;
  programs.coolercontrol.enable = true;

}
