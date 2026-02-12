{ host, pkgs, ... }:
{
  environment.pathsToLink = [
    "/share/applications"
    "/share/xdg-desktop-portal"
    "/share/zsh"
  ];

  fonts = {
    fontDir.enable = true;
    enableDefaultPackages = true;
    fontconfig = {
      enable = true;
      useEmbeddedBitmaps = true;
      subpixel.rgba = "rgb";
    };
  };

  services = {
    libinput = {
      touchpad = {
        naturalScrolling = true;
        accelProfile = "flat";
        accelSpeed = "0.75";
      };
      mouse.accelProfile = "flat";
    };
    xserver.xkb = {
      layout = "us";
      variant = "intl-unicode";
      options = "caps:ctrl_modifier";
    };

    displayManager = {
      sddm = {
        extraPackages = with pkgs.qt6; [
          qtdeclarative
          qt5compat
          qtmultimedia
          qtvirtualkeyboard
          qtsvg
        ];
        enable = host == "v7w7r-rc71l";
        wayland.enable = true;
        enableHidpi = false;
        theme = "catpuccin-mocha-mauve";
        settings.General.InputMethod = "";
      };
      ly = {
        enable = host != "v7w7r-youyeetoox1" && host != "v7w7r-rc71l";
        settings = {
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
          sleep_cmd = "systemd suspend";
          text_in_center = true;
          xinitrc = "null";
          tty = 1;
        }
        // (
          if (host == "v7w7r-rc71l" || host == "v7w7r-higole") then
            {
              battery_id = "BAT0";
            }
          else
            { }
        );
      };
    };
  };
}
