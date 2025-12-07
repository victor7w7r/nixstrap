{ ... }:
{
  services = {
    aria2.enable = true;
    cockpit.enable = true;
    dnsmasq.enable = true;
    openssh.enable = true;
    pbgopy.enable = true;
    tailscale.enable = true;
    ttyd.enable = true;
    #openvpn.package = true;
  };
}
