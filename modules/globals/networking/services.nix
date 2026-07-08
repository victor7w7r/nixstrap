{
  den.default = {
    provides.to-users.homeManager =
      { isPersistent, ... }:
      {
        services.pbgopy.enable = isPersistent;
      };

    nixos =
      { isPersistent, lib, ... }:
      {
        systemd.services = {
          NetworkManager-wait-online.enable = false;
          tailscaled = lib.optionalAttrs isPersistent {
            after = [ "network-online.target" ];
            wants = [ "network-online.target" ];
          };
        };

        services = lib.optionalAttrs isPersistent {
          #aria2.enable = true; NEEDS KEY
          #openvpn.package = true;
          croc.enable = true;
          dnsmasq.enable = true;
          tailscale = {
            enable = true;
            openFirewall = true;
            useRoutingFeatures = "server";
            extraUpFlags = [
              "--advertise-exit-node"
              "--ssh"
              "--accept-dns=true"
              "--accept-routes"
            ];
          };
          ttyd = {
            enable = false;
            writeable = true;
          };
        };
      };
  };

}
