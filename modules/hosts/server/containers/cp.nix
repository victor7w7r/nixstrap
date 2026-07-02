{ inputs, lib, ... }:
{
  den.aspects.server.containers.nixos = {
    containers.cp = {
      autoStart = false;
      privateNetwork = true;
      enableTun = true;
      ephemeral = false;
      hostAddress = "192.168.100.1";
      localAddress = "192.168.100.7";
      extraFlags = [ "--private-users-ownership=chown" ];
      additionalCapabilities = [ ''all" --system-call-filter="add_key keyctl bpf" --capability="all'' ];
      bindMounts = {
        "/opt/wand/houdini" = {
          hostPath = "/nix/persist/containers/wand/houdini";
          isReadOnly = false;
        };
        "/etc/ssh" = {
          hostPath = "/home/victor7w7r/.ssh";
          isReadOnly = true;
        };
        "/opt/wand/.data" = {
          hostPath = "/nix/persist/containers/wand/data";
          isReadOnly = false;
        };
      };

      config =
        { config, pkgs, ... }:
        {
          system.stateVersion = "26.05";

          environment.systemPackages = with pkgs; [
            git
            docker-compose
          ];

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

          systemd.services = {
            init-wand = {
              description = "Startup Wand";
              after = [
                "network.target"
                "docker.service"
              ];
              wantedBy = [ "multi-user.target" ];

              script = ''
                            mkdir -p /opt
                            cd /opt
                            if [ ! -d "wand" ]; then
                              ${pkgs.git}/bin/git clone --recurse-submodules https://github.com/solero/wand
                              rm -rf wand/.env
                            fi
                            cd wand
                            if [ ! -f ".env" ]; then
                                cat <<EOF > .env
                POSTGRES_USER=postgres
                POSTGRES_PASSWORD=postgres
                WEB_PORT=80
                WEB_HOSTNAME=localhost
                WEB_LEGACY_PLAY=http://old.localhost
                WEB_LEGACY_MEDIA=http://legacy.localhost
                WEB_VANILLA_PLAY=http://play.localhost
                WEB_VANILLA_MEDIA=http://media.localhost
                WEB_RECAPTCHA_SITE=
                WEB_RECAPTCHA_SECRET=

                EMAIL_METHOD=
                EMAIL_FROM_ADDRESS=no-reply@example.com
                EMAIL_SENDGRID_KEY=
                EMAIL_SMTP_HOST=
                EMAIL_SMTP_PORT=
                EMAIL_SMTP_USER=
                EMAIL_SMTP_PASS=
                EMAIL_SMTP_SSL=TRUE

                GAME_ADDRESS=127.0.0.1
                GAME_LOGIN_PORT=6112

                SNOWFLAKE_HOST=127.0.0.1
                SNOWFLAKE_PORT=7002
                APPLY_WINDOWMANAGER_OFFSET=False
                ALLOW_FORCESTART_SNOW=False
                ALLOW_FORCESTART_TUSK=True
                MATCHMAKING_TIMEOUT=30
                EOF
                            fi
                            ${pkgs.docker-compose}/bin/docker-compose up -d
              '';
              serviceConfig = {
                Type = "oneshot";
                RemainAfterExit = true;
              };
            };
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
                ExecStart = "${pkgs.tailscale}/bin/tailscale funnel --https 443 127.0.0.1:6112";
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
        };
    };
  };
}
