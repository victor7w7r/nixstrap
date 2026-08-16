{
  den.aspects.remote = {
    nixos = {
      systemd.services.tailscaled = {
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
      };

      services = {
        #aria2.enable = true; NEEDS KEY
        croc.enable = true;
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
          enable = true;
          writeable = true;
        };
      };
    };

    provides.to-users.homeManager = {
      services.pbgopy.enable = true;
      programs.himalaya.enable = true;
    };

  };
}
