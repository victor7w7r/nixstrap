{ host, ... }:
{
  services = {
    #aria2.enable = true; NEEDS KEY
    cockpit.enable = true;
    croc.enable = true;
    dnsmasq.enable = true;
    openssh = {
      enable = true;
    }
    // (
      if host == "v7w7r-fajita" then
        {
          settings = {
            PermitRootLogin = "yes";
            PasswordAuthentication = true;
          };
        }
      else
        { }
    );
    tailscale.enable = true;
    ttyd = {
      enable = true;
      writeable = true;
    };
    #openvpn.package = true;
  };
}
