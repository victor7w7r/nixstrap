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
      wheelNeedsPassword = false;
      extraRules = [
        {
          commands = [
            {
              command = "${pkgs.systemd}/bin/systemctl suspend";
              options = [ "NOPASSWD" ];
            }
            {
              command = "${pkgs.systemd}/bin/reboot";
              options = [ "NOPASSWD" ];
            }
            {
              command = "${pkgs.systemd}/bin/poweroff";
              options = [ "NOPASSWD" ];
            }
          ];
          groups = [ "wheel" ];
        }
      ];
    };
  };
}
