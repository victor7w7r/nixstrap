{ ... }:
{
  programs.plasma = {
    workspace = {
      colorScheme = "Layan";
      cursor.theme = "capitaine-cursors";
      enableMiddleClickPaste = false;
      iconTheme = "Colloid-Purple-Catppuccin-Dark";
      theme = "Layan";
      tooltipDelay = 1;
      windowDecorations.library = "org.kde.kwin.aurorae";
      windowDecorations.theme = "__aurorae__svg__Layan";
    };

    desktop.widgets = [
      {
        config = { };
        name = "luisbocanegra.desktop.wallpaper.effects";
        position = {
          horizontal = 51;
          vertical = 100;
        };
        size = {
          height = 250;
          width = 250;
        };
      }
      {
        config = { };
        name = "maxwell";
        position = {
          horizontal = 51;
          vertical = 100;
        };
        size = {
          height = 250;
          width = 250;
        };
      }
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

    powerdevil = {
      AC = {
        autoSuspend.action = "nothing";
        dimDisplay.enable = false;
        powerButtonAction = "shutDown";
        turnOffDisplay.idleTimeout = "never";
      };
      battery = {
        autoSuspend.action = "nothing";
        dimDisplay.enable = false;
        powerButtonAction = "shutDown";
        turnOffDisplay.idleTimeout = "never";
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
