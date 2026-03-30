{ host, self, ... }:
{
  home.file.".face.icon".source = "${self}/avatar.png";
  programs.plasma = {
    workspace = {
      colorScheme = "Layan";
      cursor.theme = "capitaine-cursors";
      enableMiddleClickPaste = false;
      iconTheme = "Colloid-Purple-Catppuccin-Dark";
      theme = "Layan";
      tooltipDelay = 1;
      wallpaper = "/etc/nixos/nixos/wallpaper.jpg";
      windowDecorations.library = "org.kde.kwin.aurorae";
      windowDecorations.theme = "__aurorae__svg__Layan";
    };

    shortcuts = {
      "KDE Keyboard Layout Switcher"."Switch to Next Keyboard Layout" = "Meta+Space";
    };

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

    kscreenlocker = {
      appearance.showMediaControls = false;
      autoLock = false;
      timeout = 0;
    };

    session = {
      general.askForConfirmationOnLogout = false;
      #sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession";
    };

    powerdevil =
      let
        is-mac = host == "v7w7r-macmini81";
      in
      {
        general.pausePlayersOnSuspend = true;
        batteryLevels = {
          criticalAction = "hibernate";
          criticalLevel = 5;
          lowLevel = 10;
        };
        AC = {
          autoSuspend = {
            action = "sleep";
            idleTimeout = if is-mac then 10800 else 3600;
          };
          turnOffDisplay = {
            idleTimeout = if is-mac then 600 else 180;
            idleTimeoutWhenLocked = 40;
          };
          dimDisplay = {
            enable = true;
            idleTimeout = if is-mac then 300 else 120;
          };
          powerButtonAction = "sleep";
          whenLaptopLidClosed = "sleep";
        };
        battery = {
          autoSuspend = {
            action = "sleep";
            idleTimeout = 300;
          };
          turnOffDisplay = {
            idleTimeout = 60;
            idleTimeoutWhenLocked = 20;
          };
          dimDisplay = {
            enable = true;
            idleTimeout = 45;
          };
          powerButtonAction = "sleep";
          whenLaptopLidClosed = "sleep";
        };
        lowBattery = {
          autoSuspend = {
            action = "sleep";
            idleTimeout = 60;
          };
          turnOffDisplay = {
            idleTimeout = 30;
            idleTimeoutWhenLocked = "immediately";
          };
          dimDisplay = {
            enable = true;
            idleTimeout = 25;
          };
          powerButtonAction = "hibernate";
          whenLaptopLidClosed = "sleep";
        };
      };

    configFile = {
      baloofilerc."Basic Settings"."Indexing-Enabled" = false;
      gwenviewrc.ThumbnailView.AutoplayVideos = true;
      plasma-localerc.Formats.LANG = "es_ES.UTF-8";
      kded5rc.Module-device_automounter.autoload = false;
      kdeglobals = {
        General = {
          BrowserApplication = "zen.desktop";
          TerminalApplication = "kitty";
          TerminalService = "kitty.desktop";
        };
        KDE = {
          AnimationDurationFactor = 0;
          ShowDeleteCommand = true;
          SmoothScroll = false;
          widgetStyle = "kvantum-dark";
        };
        "KFileDialog Settings" = {
          "Allow Expansion" = false;
          "Automatically select filename extension" = true;
          "Breadcrumb Navigation" = true;
          "Decoration position" = 2;
          "Show Full Path" = true;
          "Show Inline Previews" = true;
          "Show Preview" = false;
          "Show Speedbar" = true;
          "Show hidden files" = false;
          "Sort by" = "Name";
          "Sort directories first" = true;
          "Sort hidden files last" = false;
          "Sort reversed" = false;
          "Speedbar Width" = 143;
          "View Style" = "DetailTree";
        };
        WM = {
          activeBackground = "54,56,62";
          activeBlend = "59,62,68";
          activeForeground = "221,221,221";
          inactiveBackground = "62,65,71";
          inactiveBlend = "67,71,77";
          inactiveForeground = "120,120,120";
        };
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
      plasmaparc.General = {
        AudioFeedback = false;
        RaiseMaximumVolume = true;
        VolumeOsd = false;
        VolumeStep = 2;
      };
    };
  };
}
