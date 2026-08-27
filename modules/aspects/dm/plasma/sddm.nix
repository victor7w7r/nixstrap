{
  den.aspects.plasma.sddm.nixos =
    {
      isHandheld,
      isPhone,
      lib,
      pkgs,
      ...
    }:
    lib.mkMerge [
      {
        services = {
          displayManager.sddm.enable = isHandheld || isPhone;
          xserver.displayManager.lightdm.enable = false;

        };
        environment = {
          etc."xdg/kwinrc".source = (pkgs.formats.ini { }).generate "kwinrc" {
            Wayland."InputMethod[$e]" =
              "/run/current-system/sw/share/applications/com.github.maliit.keyboard.desktop";
            Wayland.VirtualKeyboardEnabled = "true";
            "org.kde.kdecoration2".NoPlugin = "true";
          };
          /*
            systemPackages = with pkgs; [
              (sddm-astronaut.override {
                themeConfig = {
                  # https://github.com/Keyitdev/sddm-astronaut-theme/blob/master/Themes/astronaut.conf
                  background = pkgs.fetchurl {
                    url = "https://wrothmir.is-a.dev/records/records-on-nixos/record-on-getting-started/images/featured-image.png";
                    sha256 = "sha256-7CMuETntiVUCKhUIdJzX+sf3F47GvuX2a61o4xbEzww=";
                  };
                  ScreenWidth = 1920;
                  ScreenHeight = 1080;
                  blur = false;
                };
              })
              ];
          */
        };
      }
      (lib.mkIf isPhone {
        environment = {
          etc = {
            "xdg/kdeglobals".source = (pkgs.formats.ini { }).generate "kdeglobals" {
              KDE.LookAndFeelPackage = "org.kde.plasma.phone";
            };

            "xdg/kwinrc".source = (pkgs.formats.ini { }).generate "kwinrc" {
              Wayland."InputMethod[$e]" =
                "/run/current-system/sw/share/applications/com.github.maliit.keyboard.desktop";
              Wayland.VirtualKeyboardEnabled = "true";
              "org.kde.kdecoration2".NoPlugin = "true";
            };
          };
        };

        services.displayManager = lib.mkForce {
          sddm.settings.General.DisplayServer = "wayland";
          #generic.execCmd = "exec /run/current-system/sw/bin/sddm";
          sessionPackages = with pkgs.kdePackages; [ plasma-mobile ];
          defaultSession = "plasma-mobile";
          autoLogin = {
            enable = true;
            user = "victor7w7r";
          };
        };

        security.pam.services.sddm.kwallet = {
          enable = true;
          package = pkgs.kdePackages.kwallet-pam;
        };
      })
      (lib.mkIf isHandheld {
        services.displayManager = {
          sddm = {
            package = pkgs.kdePackages.sddm;
            #theme = "sddm-astronaut-theme";
            wayland.enable = true;

            settings = {
              General = {
                #GreeterEnvironment = "QT_WAYLAND_SHELL_INTEGRATION=layer-shell";
                InputMethod = "qtvirtualkeyboard";
              };
              /*
                Theme = {
                  theme = "sddm-astronaut-theme";
                  ThemeDir = "/run/current-system/sw/share/sddm/themes";
                  FacesDir = "/var/lib/AccountsService/icons";
                  Font = "Ubuntu Nerd Font";
                  EnableAvatars = true;
                  DisableAvatarsThreshold = 7;
                };
              */
              /*
                Wayland = {
                CompositorCommand = "${pkgs.kdePackages.kwin}/bin/kwin_wayland --no-lockscreen --inputmethod maliit-keyboard";
                EnableHiDPI = true;
                };
              */
              Users = {
                #DefaultPath = "/run/current-system/sw/bin";
                RememberLastSession = true;
                RememberLastUser = true;
                ReuseSession = false;
              };
            };
          };
        };
      })
    ];
}
