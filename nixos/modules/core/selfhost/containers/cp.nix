{ pkgs, ... }:
{
  containers.cp = {
    autoStart = false;
    privateNetwork = true;
    hostBridge = "br0";
    localAddress = "192.168.1.126/24";
    additionalCapabilities = [
      "CAP_SYS_ADMIN"
      "CAP_NET_ADMIN"
      "CAP_MKNOD"
      "CAP_SYS_CHROOT"
    ];
    forwardPorts = [
      {
        containerPort = 80;
        hostPort = 80;
        protocol = "tcp";
      }
      {
        containerPort = 6112;
        hostPort = 6112;
        protocol = "tcp";
      }
      {
        containerPort = 7002;
        hostPort = 7002;
        protocol = "tcp";
      }
    ];
    bindMounts = {
      "/opt/wand/houdini" = {
        hostPath = "/nix/persist/containers/wand/houdini";
        isReadOnly = false;
      };
      "/opt/wand/.data" = {
        hostPath = "/nix/persist/containers/wand/data";
        isReadOnly = false;
      };
    };

    extraFlags = [
      "--system-call-filter=keyctl"
      "--system-call-filter=bpf"
    ];

    config =
      { lib, ... }:
      {
        system.stateVersion = "26.05";
        boot.isContainer = true;
        networking = {
          defaultGateway = "192.168.1.100";
          useHostResolvConf = lib.mkForce false;
          nameservers = [
            "1.1.1.1"
            "8.8.8.8"
          ];
          firewall = {
            enable = true;
            allowedTCPPorts = [
              80
              6112
              7002
            ];
          };
        };

        environment.systemPackages = with pkgs; [
          git
          docker-compose
        ];

        virtualisation = {
          docker = {
            enable = true;
            daemon.settings = {
              "bridge" = "none";
              "storage-driver" = "vfs";
              dns = [
                "8.8.8.8"
                "1.1.1.1"
              ];
            };
          };

          systemd.services.init-wand = {
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
        };
      };
  };
}
