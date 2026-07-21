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
        systemd.services.tailscaled = lib.optionalAttrs isPersistent {
          after = [ "network-online.target" ];
          wants = [ "network-online.target" ];
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

          chrony = {
            enable = true;
            initstepslew = {
              enabled = true;
              threshold = 1.0;
            };
            servers = [
              "1.1.1.1"
              "8.8.8.8"
              "time.cloudflare.com"
              "pool.ntp.org"
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
