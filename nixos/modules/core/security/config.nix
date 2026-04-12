{ pkgs, ... }:
{
  security = {
    apparmor = {
      enable = true;
      enableCache = true;
    };
    polkit.enable = true;
    rtkit.enable = true;
    #clamav-gui clamav-unofficial-sigs
    sudo-rs = {
      enable = true;
      package = pkgs.sudo-rs;
      execWheelOnly = true;
      wheelNeedsPassword = false;
      extraRules = [
        {
          users = [ "victor7w7r" ];
          commands = [
            {
              command = "ALL";
              options = [
                "NOPASSWD"
                "SETENV"
              ];
            }
          ];
        }
      ];
    };
  };
}
