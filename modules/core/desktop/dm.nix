{ host, ... }:
{
  services.displayManager = {
    defaultSession = "plasma";
    sddm = {
      enable = false;
      wayland.enable = false;
    };
    gdm = {
      enable = host == "v7w7r-rc71l";
      wayland = true;
    };
    ly = {
      enable = host != "v7w7r-rc71l";
      settings = {
        allow_empty_password = true;
        # matrix   -> CMatrix
        animation = "colormix";
        animation_timeout_sec = 0;
        asterisk = "*";
        auth_fails = 3;
        bg = "0x00000000";
        bigclock = "en";
        blank_box = true;
        border_fg = "0x00FFFFFF";
        box_title = null;
        brightness_down_cmd = "/usr/bin/brightnessctl -q s 10%-";
        brightness_down_key = "F5";
        brightness_up_cmd = "/usr/bin/brightnessctl -q s +10%";
        brightness_up_key = "F6";
        clear_password = false;
        clock = "%c";
        #cmatrix_fg = 0x0000FF00
        #cmatrix_min_codepoint = 0x21
        #cmatrix_max_codepoint = 0x7B
        colormix_col1 = "0x402F4F4F";
        colormix_col2 = "0x402F4F4F";
        colormix_col3 = "0x406495ED";
        console_dev = "/dev/console";
        default_input = "login";
        error_bg = "0x00000000";
        error_fg = "0x01FF0000";
        fg = "0x00FFFFFF";
        hide_borders = false;
        hide_key_hints = false;
        initial_info_text = null;
        input_len = 34;
        lang = "es";
        load = true;
        login_cmd = null;
        logout_cmd = null;
        margin_box_h = 2;
        margin_box_v = 1;
        min_refresh_delta = 5;
        numlock = false;
        path = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin";
        restart_cmd = "/sbin/shutdown -r now";
        restart_key = "F2";
        save = true;
        service_name = "ly";
        session_log = "ly-session.log";
        setup_cmd = "/etc/ly/setup.sh";
        shutdown_cmd = "/sbin/shutdown -a now";
        shutdown_key = "F1";
        sleep_cmd = "systemd suspend";
        sleep_key = "F3";
        text_in_center = true;
        vi_default_mode = "normal";
        vi_mode = false;
        waylandsessions = "/usr/share/wayland-sessions";
        x_cmd = "/usr/bin/X";
        xauth_cmd = "/usr/bin/xauth";
        xinitrc = "~/.xinitrc";
        xsessions = "/usr/share/xsessions";
      };
    };
  };
}
