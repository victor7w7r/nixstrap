{
  den.aspects.cockpit.nixos =
    { pkgs, ... }:
    {
      networking.firewall = {
        interfaces.tailscale0.allowedTCPPorts = [ 9090 ];
        allowedTCPPorts = [ 9090 ];
      };

      services.cockpit = {
        enable = true;
        showBanner = false;
        openFirewall = true;
        plugins = with pkgs; [
          cockpit-files
          cockpit-machines
          cockpit-podman
        ];
        allowed-origins = [
          "https://localhost:9090"
          "http://localhost:9090"
        ];
        settings.WebService = {
          ProtocolHeader = "X-Forwarded-Proto";
          ForwardedForHeader = "X-Forwarded-For";
          AllowUnencrypted = true;
          LoginTo = true;
          AllowMultiHost = true;
        };
      };
    };
}
