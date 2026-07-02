{ inputs, lib, ... }:
{
  den.aspects.server.containers.nixos = {
    containers.git = {
      autoStart = true;
      privateNetwork = true;
      enableTun = true;
      ephemeral = false;
      hostAddress = "192.168.100.1";
      localAddress = "192.168.100.4";
      extraFlags = [ "--private-users-ownership=chown" ];
      additionalCapabilities = [ ''all" --system-call-filter="add_key keyctl bpf" --capability="all'' ];

      bindMounts."/opt/onedev" = {
        hostPath = "/nix/persist/containers/git";
        isReadOnly = false;
      };

      config =
        { config, pkgs, ... }:
        {
          system.stateVersion = "26.05";
          imports = [ inputs.agenix.nixosModules.default ];
          age = {
            identityPaths = [ "/etc/ssh/id_ed25519" ];
            secrets.tailnet.file = ../secrets/tailnet.age;
          };
          boot.isContainer = true;
          networking = {
            hostName = "v7w7r-git";
            firewall.enable = false;
            useHostResolvConf = lib.mkForce false;
          };
          services = {
            resolved.enable = true;
            journald.extraConfig = "SystemMaxUse=100M";
            tailscale = {
              enable = true;
              openFirewall = true;
              useRoutingFeatures = "client";
              authKeyFile = config.age.secrets.tailnet.path;
              extraUpFlags = [
                "--accept-dns=true"
                "--accept-routes"
              ];
            };
          };
          systemd = {
            tmpfiles.rules = [ "d /opt/seafile-data 0770 1000 1000 - -" ];
            services = {
              tailscaled = {
                after = [ "systemd-resolved.service" ];
                wants = [ "systemd-resolved.service" ];
              };
              tailscaled-autoconnect.serviceConfig = lib.mkIf config.boot.isContainer {
                Type = lib.mkForce "exec";
              };
              funnel-client = {
                wantedBy = [ "multi-user.target" ];
                after = [ "tailscaled.service" ];
                wants = [ "tailscaled.service" ];
                serviceConfig = {
                  RestartSec = "5";
                  Restart = "on-failure";
                  User = "root";
                  ExecStart = "${pkgs.tailscale}/bin/tailscale funnel 6610";
                };
              };
              funnel-ssh = {
                wantedBy = [ "multi-user.target" ];
                after = [ "tailscaled.service" ];
                wants = [ "tailscaled.service" ];
                serviceConfig = {
                  RestartSec = "5";
                  Restart = "on-failure";
                  User = "root";
                  ExecStart = "${pkgs.tailscale}/bin/tailscale funnel 6611 --https 8443";
                };
              };
            };
          };

          virtualisation.docker = {
            enable = true;
            autoPrune = {
              enable = true;
              dates = "weekly";
            };
            rootless = {
              enable = false;
              setSocketVariable = true;
            };
          };

          virtualisation.oci-containers.backend = "docker";
          virtualisation.oci-containers.containers.onedev = {
            image = "1dev/server";
            autoStart = true;
            ports = [
              "6610:6610"
              "6611:6611"
            ];
            environment = {
              # initial_server_url = "https://${builtins.toString networkConfig.publicIp}/onedev/";
            };
            extraOptions = [ "--network=host" ];
            volumes = [
              "onedev:/opt/onedev"
              "/var/run/docker.sock:/var/run/docker.sock"
            ];
          };
        };
    };
  };
}
