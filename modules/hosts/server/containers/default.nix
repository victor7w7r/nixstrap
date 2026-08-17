{
  stateVersion,
  inputs,
  lib,
  ...
}:
{
  imports = [ (inputs.den.namespace "containers" false) ];

  containers.lib = {
    funnel =
      {
        pkgs,
        incoming ? null,
        incomingTcp ? null,
        outgoingTcp ? null,
      }:
      {
        wantedBy = [ "multi-user.target" ];
        after = [ "tailscaled.service" ];
        wants = [ "tailscaled.service" ];
        serviceConfig = {
          RestartSec = "10s";
          Restart = "on-failure";
          User = "root";
          ExecStart = ''
            ${pkgs.tailscale}/bin/tailscale funnel --bg \
              ${lib.optionalString (incoming != null) ''
                https+insecure://localhost:${incoming} \
              ''}
              ${lib.optionalString (incomingTcp != null && outgoingTcp != null) ''
                --tcp=${outgoingTcp} tcp://localhost:${incomingTcp}
              ''}
          '';
        };
      };

    call =
      {
        ip,
        bindMounts,
        name,
        extra ? pkgs: { },
        containers ? config: { },
        forwardPorts ? [ ],
        services ? config: pkgs: { },
        secrets ? { },
        systemd ? pkgs: { },
        rules ? [ ],
      }:
      {
        autoStart = true;
        privateNetwork = true;
        enableTun = true;
        ephemeral = false;
        hostAddress = "192.168.1.1";
        localAddress = "192.168.1.${ip}";
        extraFlags = [ "--private-users-ownership=chown" ];
        additionalCapabilities = [ ''all" --system-call-filter="add_key keyctl bpf" --capability="all'' ];
        inherit forwardPorts;
        bindMounts = {
          "/etc/ssh" = {
            hostPath = "/home/victor7w7r/.ssh";
            isReadOnly = true;
          };
        }
        // bindMounts;

        config =
          { config, pkgs, ... }:
          {
            system.stateVersion = stateVersion;
            imports = [ inputs.agenix.nixosModules.default ];
            boot.isContainer = true;
            age = {
              identityPaths = [ "/etc/ssh/id_ed25519" ];
              inherit secrets;
            };
            networking = {
              hostName = "v7w7r-${name}";
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
            }
            // (services config pkgs);

            systemd = {
              tmpfiles.rules = rules;
              services = {
                tailscaled-autoconnect.serviceConfig = {
                  Type = lib.mkForce "exec";
                };
                tailscaled = {
                  after = [ "systemd-resolved.service" ];
                  wants = [ "systemd-resolved.service" ];
                };
              }
              // (systemd pkgs);
            };

            virtualisation = {
              docker = {
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
              oci-containers = {
                containers = (containers config);
                backend = "docker";
              };
            };
          }
          // (extra pkgs);
      };
  };
}
