{
  den.aspects.plasma.desktop.provides.to-users.homeManager =
    { lib, ... }:
    {
      programs.plasma = {
        desktop.widgets = [
          {
            config = {
              General = {
                GrainMode = 4;
                PixelateMode = 4;
                hideWidget = true;
                isEnabled = false;
              };
            };
            name = "luisbocanegra.desktop.wallpaper.effects";
            position = {
              vertical = 1080 - 32;
              horizontal = 1920 - 51;
            };
            size = {
              height = 25;
              width = 25;
            };
          }
          /*
            {
            name = "maxwell";
            config.General.speed = 2.2;
            position = {
              horizontal = 51;
              vertical = 100;
            };
            size = {
              height = 100;
              width = 100;
            };
            }
          */
        ];
        kwin = {
          borderlessMaximizedWindows = true;
          effects = {
            blur.enable = false;
            translucency.enable = true;
          };
          nightLight = {
            enable = true;
            mode = "constant";
            temperature = {
              day = 3600;
              night = 4300;
            };
          };
          tiling.padding = 4;
          titlebarButtons = {
            left = [
              "close"
              "minimize"
              "maximize"
            ];
            right = [ "keep-above-windows" ];
          };
        };
        configFile = {
          kwinrc = {
            Effect-better-blur-dx.BlurDecorations = true;
            Effect-better-blur-dx.BlurDocks = true;
            Effect-better-blur-dx.WindowClasses = "dolphin\nkitty\nzen\nplasmashell";
            Effect-overview.OrganizedGrid = false;
            Effect-translucency.DropdownMenus = 17;
            Effect-translucency.MoveResize = 100;
            Effect-translucency.PopupMenus = 18;
            Effect-translucency.TornOffMenus = 19;
            EdgeBarrier = {
              CornerBarrier = false;
              EdgeBarrier = 0;
            };
            Input.TabletMode = "off";
            Plugins = lib.mkForce {
              blurEnabled = false;
              better_blur_dxEnabled = true;
              contrastEnabled = true;
              desktopchangeosdEnabled = false;
              dimscreenEnabled = true;
              fullscreenifyEnabled = false;
              kzonesEnabled = true;
              macsimize6Enabled = false;
              minimizeallEnabled = true;
              mousemarkEnabled = true;
              screenedgeEnabled = false;
              sticky-window-snappingEnabled = true;
              temporary-virtual-desktopsEnabled = false;
              translucencyEnabled = true;
              truely-maximizedEnabled = true;
              virtual-desktops-only-on-primaryEnabled = true;
              zoomEnabled = false;
            };
            TabBox.HighlightWindows = false;
            TabBox.LayoutName = "thumbnail_grid";
            TabBoxAlternative.ActivitiesMode = 0;
            TabBoxAlternative.DesktopMode = 0;
            TabBoxAlternative.MultiScreenMode = 1;
            Wayland.EnablePrimarySelection = false;
          };
          plasmaparc.General = {
            AudioFeedback = false;
            RaiseMaximumVolume = true;
            VolumeOsd = false;
            VolumeStep = 2;
          };
          plasmanotifyrc = {
            DoNotDisturb = {
              WhenFullscreen = false;
              WhenScreenSharing = false;
              WhenScreensMirrored = false;
            };
            Notifications = {
              PopupPosition = "TopRight";
              PopupTimeout = 3000;
            };
            "Applications/zen".Seen = true;
            "Services/powerdevil".ShowInHistory = false;
            "Services/powerdevil".ShowPopups = false;
          };
        };
      };
    };
}
