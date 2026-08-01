{ containers, ... }:
{
  den.aspects.server.containers.nixos.containers.git = containers.lib.call {
    ip = "4";
    name = "git";
    bindMounts."/opt/onedev" = {
      hostPath = "/nix/persist/containers/git";
      isReadOnly = false;
    };
    secrets.tailnet.file = ../secrets/tailnet.age;
    systemd = pkgs: {
      funnel-db = containers.lib.funnel {
        inherit pkgs;
        outcoming = "6610";
      };
      funnel-ssh = containers.lib.funnel {
        inherit pkgs;
        incoming = "6611";
        outcoming = "8443";
      };
    };
    containers = _: {
      onedev = {
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
}
