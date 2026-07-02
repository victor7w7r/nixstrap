{
  den.default.nixos =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        #boxxy
        firejail
        luksmeta
        veracrypt
      ];

      /*
        services.udev.packages = [ pkgs.yubikey-personalization ];
        services.pcscd.enable = true;
        environment.systemPackages = with pkgs; [ yubikey-manager ];
          hardware.gpgSmartcards.enable = true;
      */
      services = {
        fail2ban.enable = true;
        #opensnitch.enable = true;
        #clamav = {
        #  daemon.enable = true;
        #  updater.enable = true;
        #  scanner.enable = true;
        #};
        #
      };

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
            }
          ];
        };
      };
    };
}
