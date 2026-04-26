{
  config,
  lib,
  host,
  pkgs,
  ...
}:
{
  services = {
    #aria2.enable = true; NEEDS KEY
    cockpit = {
      enable = host == "v7w7r-macmini81" || host == "v7w7r-youyeetoox1";
      plugins = with pkgs; [
        cockpit-zfs
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
            "https://${config.sops.placeholder.tunnel}:443/pc"
          ]
        );
      };

    };
    croc.enable = true;
    dnsmasq.enable = true;
    tailscale.enable = host != "v7w7r-opizero2w";
    ttyd = {
      enable = true;
      writeable = true;
    };
    #openvpn.package = true;
  }

  // (
    if host == "v7w7r-fajita" then
      {
        openssh = lib.mkForce {
          enable = true;
          settings = {
            AcceptEnv = null;
            PermitRootLogin = "yes";
            PasswordAuthentication = true;
          };
        };
      }
    else
      {
        openssh = lib.mkForce {
          settings.AcceptEnv = null;
          enable = true;
        };
      }
  );

}
