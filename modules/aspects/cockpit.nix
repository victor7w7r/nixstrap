{
  den.aspects.cockpit.nixos =
    { lib, pkgs, ... }:
    {
      services.cockpit = {
        enable = true;
        plugins = with pkgs; [
          cockpit-files
          cockpit-machines
          cockpit-podman
        ];
        settings.WebService = {
          ProtocolHeader = "X-Forwarded-Proto";
          AllowUnencrypted = true;
          LoginTo = true;
          AllowMultiHost = true;
          Origins = lib.mkForce (
            builtins.concatStringsSep " " [
              "http://127.0.0.1:9090"
              "http://192.168.1.100:9090"
              #"https://${config.sops.placeholder.tunnel}:443/pc"
            ]
          );
        };
      };
    };
}
