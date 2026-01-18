{ ... }:
{
  services = {
    avahi = {
      enable = true;
      browseDomains = [ ];
      wideArea = false;
      nssmdns = true;
    };

    hardware.bolt.enable = true;

    unbound = {
      enable = true;
      settings.server = {
        access-control = [ ];
        interface = [ ];
      };
    };

    getty.autologinUser = "nixstrap";
    openssh = {
      enable = true;
      settings.PermitRootLogin = "yes";
    };

    vnstat.enable = true;
    timesyncd.enable = true;
    xserver.exportConfiguration = true;
  };
}
