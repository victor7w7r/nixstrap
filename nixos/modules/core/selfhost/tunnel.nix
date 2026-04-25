{ pkgs, lib, ... }:
let
  mkFunnel = name: publicport: localport: {
    systemd.services."funnel-${name}" = {
      wantedBy = [ "multi-user.target" ];
      after = [ "tailscaled.service" ];
      wants = [ "tailscaled.service" ];
      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        RestartSec = "10s";
        User = "root";
        ExecStart = "${pkgs.tailscale}/bin/tailscale funnel --https ${toString publicport} 127.0.0.1:${toString localport}";
      };
    };
  };
in
lib.mkMerge [
  (mkFunnel "1" 443 443)
  (mkFunnel "2" 8443 8443)
  (mkFunnel "3" 10000 10000)
]
