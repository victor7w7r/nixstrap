{ ... }:
{
  services = {
    #aria2.enable = true; NEEDS KEY
    cockpit.enable = true;
    croc.enable = true;
    dnsmasq.enable = true;
    openssh.enable = true;
    tailscale.enable = true;
    ttyd = {
      enable = true;
      writeable = true;
    };
    #openvpn.package = true;
  };
}
