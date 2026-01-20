{ lib, ... }:
{
  services = {
    hardware.bolt.enable = true;
    logrotate.enable = lib.mkDefault false;
    getty.autologinUser = "nixstrap";
    openssh = {
      enable = true;
      settings.PermitRootLogin = "yes";
    };
    vnstat.enable = true;
    speechd.enable = false;
    timesyncd.enable = true;
    xserver.exportConfiguration = true;
  };
}
