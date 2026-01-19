{ ... }:
{
  services = {
    hardware.bolt.enable = true;
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
