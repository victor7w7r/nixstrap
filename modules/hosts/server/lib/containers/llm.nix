{ inputs, lib, ... }:
{
  den.aspects.server.provides.containers.nixos = {
    containers.llm = {
      # hardware.graphics.enable = true;
      autoStart = false;
      privateNetwork = true;
      enableTun = true;
      ephemeral = false;
      hostAddress = "192.168.100.1";
      localAddress = "192.168.100.5";
      bindMounts = {
        "/etc/ssh" = {
          hostPath = "/home/victor7w7r/.ssh";
          isReadOnly = true;
        };
        "/dev/dri" = {
          hostPath = "/dev/dri";
          isReadOnly = false;
        };
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
            hostName = "v7w7r-llm";
            firewall.enable = false;
            useHostResolvConf = lib.mkForce false;
          };
          hardware.graphics = {
            enable = true;
            extraPackages = [ pkgs.intel-compute-runtime ];
          };

          nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "open-webui" ];

          systemd.services.ollama.environment = {
            OLLAMA_INTEL_GPU = "1";
            OLLAMA_ORIGINS = "chrome-extension://*,moz-extension://*";
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
            open-webui = {
              enable = true;
              port = 3500;
              environment.OLLAMA_BASE_URL = "http://127.0.0.1:11434";
            };
            ollama = {
              enable = true;
              loadModels = [
                "mistral"
                "dolphin-llama3:8b"
                "solar:10.7b"
              ];
            };
          };

          systemd.services = {
            tailscaled = {
              after = [ "systemd-resolved.service" ];
              wants = [ "systemd-resolved.service" ];
            };
            funnel = {
              wantedBy = [ "multi-user.target" ];
              after = [ "tailscaled.service" ];
              wants = [ "tailscaled.service" ];
              serviceConfig = {
                RestartSec = "5";
                Restart = "on-failure";
                User = "root";
                ExecStart = "${pkgs.tailscale}/bin/tailscale funnel --https 443 127.0.0.1:3500";
              };
            };
          };
        };
    };
  };
}
