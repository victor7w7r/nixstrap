{
  den.default.nixos =
    {
      isPersistent,
      isTpm,
      lib,
      pkgs,
      ...
    }:
    {
      environment = {
        persistence = lib.optionalAttrs isPersistent {
          "/nix/persist".directories = [ (lib.mkIf isTpm "/var/lib/sbctl") ];
        };
        systemPackages = with pkgs; [
          #boxxy
          firejail
          luksmeta
          pam_u2f
          veracrypt
          yubikey-manager
        ];
      };

      programs.yubikey-manager.enable = true;

      services = {
        fail2ban.enable = true;
        udev.packages = with pkgs; [ yubikey-personalization ];
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
        #clamav-gui clamav-unofficial-sigs
        pam = {
          services = {
            login.u2fAuth = true;
            sudo.u2fAuth = true;
            y2f.enable = true;
          };
          u2f = {
            enable = true;
            control = "sufficient";
            settings = {
              cue = true;
              authFile = "/etc/u2f_keys";
            };
          };
        };
        polkit.enable = true;
        rtkit.enable = true;
        sudo-rs = {
          enable = true;
          package = pkgs.sudo-rs;
          execWheelOnly = true;
          wheelNeedsPassword = false;
          extraRules = [
            {
              users = [
                "victor7w7r"
                "snowflake"
              ];
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
    };
}
