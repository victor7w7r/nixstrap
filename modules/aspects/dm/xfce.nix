{
  den.aspects.xfce = {
    nixos =
      { pkgs, self', ... }:
      {
        security.pam.services.gdm.enableGnomeKeyring = true;

        programs = {
          dconf.enable = true;
          thunar = {
            enable = true;
            plugins = with pkgs; [
              thunar-archive-plugin
              thunar-volman
            ];
          };
        };

        services = {
          displayManager.defaultSession = "xfce";
          xserver = {
            excludePackages = with pkgs; [ xterm ];
            displayManager.lightdm.enable = false;
            desktopManager = {
              xterm.enable = false;
              xfce = {
                enable = true;
                enableScreensaver = false;
              };
            };
            xkb = {
              layout = "us";
              variant = "intl-unicode";
            };
          };
        };

        environment = {
          sessionVariables.ADW_DEBUG_COLOR_SCHEME = "prefer-dark";
          pathsToLink = [ "/share/backgrounds" ];
          xfce.excludePackages = with pkgs; [
            gnome-themes-extra
            parole
            pavucontrol
            ristretto
            xfce4-notifyd
            xfce4-screensaver
            xfce4-screenshooter
            xfce4-terminal
            xfce4-volumed-pulse
          ];
          systemPackages = with pkgs; [
            blueman
            deja-dup
            epiphany
            xarchiver
            xclip
            xsel
            catfish
            gigolo
            xarchiver
            xfce4-appfinder
            xfce4-clipman-plugin
            xfce4-cpufreq-plugin
            xfce4-cpugraph-plugin
            xfce4-fsguard-plugin
            xfce4-genmon-plugin
            xfce4-netload-plugin
            xfce4-panel
            xfce4-panel-profiles
            xfce4-taskmanager
            xfce4-sensors-plugin
            xfce4-systemload-plugin
            xfce4-whiskermenu-plugin
            xfce4-xkb-plugin
            xfdashboard
            thunar-shares-plugin
            self'.packages.gtkhash-thunar
            self'.packages.thunar-custom-actions
            self'.packages.xfce4-diskperf-plugin
            self'.packages.xfce4-mount-plugin
          ];
        };
      };

    provides.to-users.homeManager = {
      qt.enable = false;
      xfconf.settings = {
        xsettings = {
          "Gtk/MonospaceFontName" = "UbuntuMono Nerd Font 11";
          "Gtk/FontName" = "Ubuntu Nerd Font 10";
          "Net/IconThemeName" = "Colloid-Purple-Catppuccin-Dark";
          "Net/ThemeName" = "Layan-Dark";
        };
        xfwm4 = {
          "general/theme" = "Layan-Dark";
        };
        xfce4-power-manager = {
          "lid-action-on-ac" = 1;
          "lock-screen-suspend-hibernate" = false;
        };
        xfce4-desktop = {
          "desktop-icons/style" = 1;
        };
      };
    };
  };
}
