{ pkgs, ... }:
{
  systemd.services.funnel = {
    description = "Tailscale Funnel for localhost on port 9090";
    wantedBy = [ "multi-user.target" ];
    after = [ "tailscaled.service" ];
    wants = [ "tailscaled.service" ];
    serviceConfig = {
      Type = "oneshot";
      Restart = "on-failure";
      RestartSec = "5s";
      RemainAfterExit = true;
      ExecStart = "${pkgs.tailscale}/bin/tailscale funnel --https 8443 --yes 127.0.0.1:9090"; # 443, 10000
    };
  };
}
