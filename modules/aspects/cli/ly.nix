{
  den.aspects.cli.ly.nixos =
    { lib, pkgs, ... }@args:
    {
      security.pam.services.ly.kwallet = {
        enable = true;
        package = pkgs.kdePackages.kwallet-pam;
      };

      services.displayManager.ly = {
        enable = true;
        settings = lib.mkMerge [
          {
            animation = "gameoflife";
            auth_fails = 3;
            bg = "0x00000000";
            bigclock = "en";
            blank_box = true;
            border_fg = "0x00FFFFFF";
            brightness_down_cmd = "${pkgs.brightnessctl}/bin/brightnessctl -q s 10%-";
            brightness_up_cmd = "${pkgs.brightnessctl}/bin/brightnessctl -q s +10%";
            clock = "%c";
            #colormix_col1 = "0x402F4F4F";
            #colormix_col2 = "0x402F4F4F";
            #colormix_col3 = "0x406495ED";
            gameoflife_fg = "0x0000FF00";
            gameoflife_frame_delay = 9;
            gameoflife_entropy_interval = 5;
            default_input = "login";
            error_bg = "0x00000000";
            error_fg = "0x01FF0000";
            fg = "0x00FFFFFF";
            hide_version_string = true;
            lang = "es";
            session_log = ".local/state/ly-session.log";
            sleep_cmd = "systemd suspend";
            text_in_center = true;
            xinitrc = "null";
            tty = 1;
          }
          (lib.mkIf args.isHandheld {
            battery_id = "BAT0";
          })
        ];
      };
    };
}
