{ lib, host, ... }:
{
  services = {
    #aria2.enable = true; NEEDS KEY
    cockpit.enable = true;
    croc.enable = true;
    dnsmasq.enable = true;
    tailscale.enable = host != "v7w7r-opizero2w";
    ttyd = {
      enable = true;
      writeable = true;
    };
    #openvpn.package = true;
  }

  // (
    if host == "v7w7r-fajita" then
      {
        openssh = lib.mkForce {
          enable = true;
          settings = {
            AcceptEnv = null;
            PermitRootLogin = "yes";
            PasswordAuthentication = true;
          };
        };
      }
    else
      {
        openssh = lib.mkForce {
          settings.AcceptEnv = null;
          enable = true;
        };
      }
  );

}
