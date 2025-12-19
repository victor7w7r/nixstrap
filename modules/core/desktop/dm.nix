{ pkgs, ... }:
{
  services.displayManager = {
    defaultSession = "plasma";
    sddm = {
      extraPackages = with pkgs.kdePackages; [
        qtsvg
        qtmultimedia
        qtvirtualkeyboard
      ];
      enable = false;
      wayland.enable = false;
      enableHidpi = false;
      settings = {
        General = {
          InputMethod = "";
        };
      };
    };
    ly = {
      enable = true;
      settings = {
        animation = "colormix"; # matrix, CMatrix
        auth_fails = 3;
        bg = "0x00000000";
        bigclock = "en";
        blank_box = true;
        border_fg = "0x00FFFFFF";
        brightness_down_cmd = "${pkgs.brightnessctl}/bin/brightnessctl -q s 10%-";
        brightness_up_cmd = "${pkgs.brightnessctl}/bin/brightnessctl -q s +10%";
        clock = "%c";
        colormix_col1 = "0x402F4F4F";
        colormix_col2 = "0x402F4F4F";
        colormix_col3 = "0x406495ED";
        default_input = "login";
        error_bg = "0x00000000";
        error_fg = "0x01FF0000";
        fg = "0x00FFFFFF";
        hide_version_string = true;
        lang = "es";
        sleep_cmd = "systemd suspend";
        text_in_center = true;
      };
    };
  };
}
