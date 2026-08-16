{
  den.default = {
    nixos =
      {
        isPersistent,
        isPhone,
        isLive,
        lib,
        ...
      }:
      {
        systemd.services.tailscaled = lib.optionalAttrs isPersistent {
          after = [ "network-online.target" ];
          wants = [ "network-online.target" ];
        };

        services = {
          #aria2.enable = true; NEEDS KEY
          croc.enable = isPersistent;
          dnsmasq = {
            enable = false;
            settings = {
              interface = [
                "lo"
                "wlp6s0"
                "enp1s0"
                "enp4s0"
              ];
              bind-interfaces = true;
              except-interface = [ "virbr0" ];
            };
          };
          openssh = lib.mkForce {
            enable = true;
            settings = {
              AcceptEnv = null;
              PermitRootLogin = if (isPhone || isLive) then "yes" else lib.mkDefault "prohibit-password";
              PasswordAuthentication = true;
              MaxAuthTries = 3;
              ClientAliveInterval = 300;
              ClientAliveCountMax = 2;
            };
          };
          tailscale = {
            enable = isPersistent;
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
            enable = isPersistent;
            writeable = true;
          };
        };
      };

    provides.to-users.homeManager =
      { isPersistent, ... }:
      {
        services.pbgopy.enable = isPersistent;
      };
  };
}
