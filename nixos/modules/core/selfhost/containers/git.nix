{ ... }:
{
  containers.git = {
    autoStart = true;
    privateNetwork = true;
    hostBridge = "br0";
    localAddress = "192.168.1.122/24";
    forwardPorts = [
      {
        containerPort = 2222;
        hostPort = 2222;
        protocol = "tcp";
      }
    ];
    bindMounts = {
      "/var/lib/gogs" = {
        hostPath = "/nix/persist/containers/gogs";
        isReadOnly = false;
      };
    };

    config =
      { ... }:
      {
        networking.firewall.allowedTCPPorts = [ 2222 ];
        system.stateVersion = "26.05";
        services.gogs = {
          enable = true;
          stateDir = "/var/lib/gogs";
          database = {
            type = "postgres";
            host = "127.0.0.1";
            port = 5432;
            passwordFile = "/etc/nix/gogs-pw";
          };
          domain = "git.v7w7r.local";
          rootUrl = "https://git.v7w7r.local";
          httpPort = 3001;
          cookieSecure = true;
          extraConfig = ''
            [server]
            START_SSH_SERVER = true
            SSH_PORT = 2222
            SSH_LISTEN_PORT = 2222

            OFFLINE_MODE = true
            DISABLE_REGISTRATION = true
            REQUIRE_SIGNIN_VIEW = true

            [log]
            ROOT_PATH = /var/lib/gogs/log
          '';
        };
      };
  };
}
