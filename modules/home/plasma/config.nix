{ pkgs, lib, ... }:
with lib;
{

  services.gpg-agent = {
    pinentry.package = pkgs.kwalletcli;
    extraConfig = "pinentry-program ${pkgs.kwalletcli}/bin/pinentry-kwallet";
  };

  programs.plasma = {
    enable = true;
    overrideConfig = true;

    workspace = {
      enableMiddleClickPaste = false;
      lookAndFeel = "com.github.vinceliuice.Layan";
      cursor.theme = "capitaine-cursors";
      splashScreen.engine = "none";
      splashScreen.theme = "none";
      tooltipDelay = 1;
    };

    fonts = {
      general = {
        family = "Ubuntu";
        pointSize = 10;
      };

      fixedWidth = {
        family = "JetBrainsMonoNL Nerd Font Mono";
        pointSize = 10;
      };

      small = {
        family = "Ubuntu";
        pointSize = 8;
      };

      toolbar = {
        family = "Ubuntu";
        pointSize = 10;
      };

      menu = {
        family = "Ubuntu";
        pointSize = 10;
      };

      windowTitle = {
        family = "Ubuntu";
        pointSize = 10;
      };
    };

    kscreenlocker = {
      appearance.showMediaControls = false;
      autoLock = false;
      timeout = 0;
    };

    session = {
      general.askForConfirmationOnLogout = false;
      #sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession";
    };

    kwin = {
      borderlessMaximizedWindows = true;
      effects = {
        blur = {
          enable = false;
          strength = 2;
          noiseStrength = 2;
        };
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

    input = {
      keyboard = {
        layouts = [
          {
            layout = "us";
            displayName = "us";
            variant = "workman-intl";
          }
          {
            layout = "latam";
            displayName = "es";
          }
        ];
        options = [ "caps:ctrl_modifier" ];
      };

      mice = [
        /*
          {
          accelerationProfile = "none";
          name = "ydotoold virtual device";
          }
        */
      ];

      touchpads = [
        {
          accelerationProfile = "none";
          enable = true;
          leftHanded = false;
          middleButtonEmulation = true;
          name = "Wacom Intuos5 touch S Finger";
          naturalScroll = true;
          pointerSpeed = 0;
          productId = "056a";
          rightClickMethod = "twoFingers";
          scrollMethod = "twoFingers";
          tapAndDrag = false;
          tapToClick = true;
          vendorId = "0026";
        }
      ];
    };

    panels = [
      {
        location = "bottom";
        alignment = "center";
        lengthMode = "fit";
        floating = true;
        height = 44;
        hiding = "autohide";
        screen = 0;
        opacity = "translucent";
        widgets = [
          {
            iconTasks = {
              appearance = {
                showTooltips = true;
                highlightWindows = true;
                indicateAudioStreams = true;
                fill = true;
              };
              launchers = [
                "preferred://filemanager"
                "applications:zen.desktop"
                "applications:kitty.desktop"
                "applications:dev.zed.Zed.desktop"
              ];
            };
          }
          "org.kde.plasma.trash"
        ];
      }

      {
        location = "top";
        alignment = "center";
        lengthMode = "fill";
        floating = true;
        height = 32;
        hiding = "none";
        screen = "all";
        opacity = "adaptive";
        widgets = [
          {
            applicationTitleBar = {
              layout.elements = [ ];
              windowControlButtons = {
                iconSource = "breeze";
                buttonsAspectRatio = 95;
                buttonsMargin = 0;
              };
              windowTitle = {
                source = "appName";
                hideEmptyTitle = true;
                undefinedWindowTitle = "";
                margins = {
                  left = 5;
                  right = 5;
                };
              };
              overrideForMaximized = {
                enable = true;
                elements = [
                  "windowCloseButton"
                  "windowMaximizeButton"
                  "windowMinimizeButton"
                  "windowIcon"
                  "windowTitle"
                ];
                source = "appName";
              };
            };
          }
          "org.kde.plasma.appmenu"
          "org.kde.plasma.panelspacer"
          {
            systemTray = {
              icons.scaleToFit = true;
              items = {
                showAll = false;
                shown = [
                  "org.kde.plasma.keyboardlayout"
                  "org.kde.plasma.networkmanagement"
                  "org.kde.plasma.volume"
                ];
                hidden = [
                  "org.kde.plasma.battery"
                  "org.kde.plasma.brightness"
                  "org.kde.plasma.clipboard"
                  "org.kde.plasma.devicenotifier"
                  "org.kde.plasma.mediacontroller"
                  "plasmashell_microphone"
                  "xdg-desktop-portal-kde"
                  "zoom"
                ];
                configs = {
                  "org.kde.plasma.notifications".config = {
                    Shortcuts = {
                      global = "Meta+N";
                    };
                  };
                };
              };
            };
          }
          {
            digitalClock = {
              date = {
                enable = true;
                position = "besideTime";
              };
              time.showSeconds = "always";
            };
          }
        ];
      }
    ];

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
      dolphinrc = {
        ContentDisplay.UsePermissionsFormat = "NumericFormat";
        ContextMenu = {
          ShowOpenInNewTab = false;
          ShowOpenInNewWindow = false;
          ShowOpenTerminal = false;
        };
        ExtractDialog = {
          "3 screens: Height" = 480;
          "3 screens: Width" = 844;
          "DirHistory[$e]" = "$HOME/";
        };
        General = {
          DynamicView = true;
          FilterBar = true;
          GlobalViewProps = false;
          OpenNewTabAfterLastTab = true;
          ShowFullPath = true;
          ShowStatusBar = "FullWidth";
          ShowToolTips = true;
          ShowZoomSlider = true;
          UseTabForSwitchingSplitView = true;
          ViewPropsTimestamp = "2025,9,30,20,15,20.832";
        };
        InformationPanel.dateFormat = "ShortFormat";
        "KFileDialog Settings"."Places Icons Auto-resize" = false;
        "KFileDialog Settings"."Places Icons Static Size" = 22;
        "Notification Messages".warnAboutRisksBeforeActingAsAdmin = false;
        PreviewSettings.Plugins = "appimagethumbnail,cursorthumbnail,mobithumbnail,audiothumbnail,textthumbnail,fontthumbnail,ffmpegthumbs,djvuthumbnail,gsthumbnail,rawthumbnail,directorythumbnail,kraorathumbnail,opendocumentthumbnail,windowsexethumbnail,avif,glycin-heif,heif,glycin-image-rs,glycin-jxl,jxl,librsvg,glycin-svg,imagethumbnail,windowsimagethumbnail,exrthumbnail,jpegthumbnail,svgthumbnail,comicbookthumbnail,ebookthumbnail,exe-thumbnailer";
      };
      kcminputrc = {
        "ButtonRebinds/Tablet/Wacom Intuos5 touch S (WL) Pad"."0" = "Disabled";
        "ButtonRebinds/Tablet/Wacom Intuos5 touch S (WL) Pad"."1" = "Disabled";
        "ButtonRebinds/Tablet/Wacom Intuos5 touch S (WL) Pad"."2" = "Disabled";
        "ButtonRebinds/Tablet/Wacom Intuos5 touch S (WL) Pad"."3" = "Disabled";
        "ButtonRebinds/Tablet/Wacom Intuos5 touch S (WL) Pad"."4" = "Disabled";
        "ButtonRebinds/Tablet/Wacom Intuos5 touch S (WL) Pad"."5" = "Disabled";
        "ButtonRebinds/Tablet/Wacom Intuos5 touch S (WL) Pad"."6" = "Disabled";
        "ButtonRebinds/TabletRing/Wacom Intuos5 touch S (WL) Pad/0"."0" = "Disabled";
        "ButtonRebinds/TabletRing/Wacom Intuos5 touch S (WL) Pad/1"."0" = "Disabled";
        "ButtonRebinds/TabletRing/Wacom Intuos5 touch S (WL) Pad/2"."0" = "Disabled";
        "ButtonRebinds/TabletRing/Wacom Intuos5 touch S (WL) Pad/3"."0" = "Disabled";
        "ButtonRebinds/TabletTool/Wacom Intuos5 touch S (WL) Pen"."0" = "Disabled";
        "ButtonRebinds/TabletTool/Wacom Intuos5 touch S (WL) Pen"."1" = "MouseButton,273";
        "ButtonRebinds/TabletTool/Wacom Intuos5 touch S Pen"."0" = "Disabled";
        "ButtonRebinds/TabletTool/Wacom Intuos5 touch S Pen"."1" = "MouseButton,273";
        "ButtonRebinds/TabletTool/Wacom Intuos5 touch S Pen"."331" = "MouseButton,274";
        "ButtonRebinds/TabletTool/Wacom Intuos5 touch S Pen"."332" = "MouseButton,273";
        "Libinput/1241/41119/E-Signal USB Gaming Mouse".PointerAccelerationProfile = 1;
        "Libinput/1386/38/Wacom Intuos5 touch S (WL) Pen".MapToWorkspace = true;
        "Libinput/1386/38/Wacom Intuos5 touch S Pen".MapToWorkspace = true;
      };
      kdeglobals = {
        General = {
          BrowserApplication = "zen.desktop";
          TerminalApplication = "kitty";
          TerminalService = "kitty.desktop";
        };
        Icons.Theme = "Colloid-Purple-Dark";
        KDE = {
          AnimationDurationFactor = 0;
          ShowDeleteCommand = true;
          SmoothScroll = false;
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
      kiorc = {
        Confirmations.ConfirmDelete = false;
        Confirmations.ConfirmEmptyTrash = false;
        Confirmations.ConfirmTrash = false;
        "Executable scripts".behaviourOnLaunch = "alwaysAsk";
      };
      kservicemenurc.Show = {
        compressfileitemaction = true;
        decrypt-view = false;
        encrypt = false;
        extractfileitemaction = true;
        filelight = true;
        forgetfileitemaction = true;
        installFont = true;
        kactivitymanagerd_fileitem_linking_plugin = false;
        kdeconnectfileitemaction = true;
        kio-admin = true;
        makefileactions = false;
        mountisoaction = true;
        movetonewfolderitemaction = true;
        plasmavaultfileitemaction = false;
        runInKonsole = true;
        setfoldericonitemaction = true;
        sharefileitemaction = false;
        slideshowfileitemaction = true;
        tagsfileitemaction = false;
        wallpaperfileitemaction = true;
      };
      ktrashrc = {
        "\\/home\\/victor7w7r\\/.local\\/share\\/Trash".Days = 7;
        "\\/home\\/victor7w7r\\/.local\\/share\\/Trash".LimitReachedAction = 0;
        "\\/home\\/victor7w7r\\/.local\\/share\\/Trash".Percent = 10;
        "\\/home\\/victor7w7r\\/.local\\/share\\/Trash".UseSizeLimit = true;
        "\\/home\\/victor7w7r\\/.local\\/share\\/Trash".UseTimeLimit = false;
      };
      kwinrc = {
        Effect-blurplus.BlurDecorations = true;
        Effect-blurplus.BlurDocks = true;
        Effect-blurplus.WindowClasses = "dolphin\norg.wezfurlong.wezterm";
        Effect-overview.OrganizedGrid = false;
        Effect-translucency.DropdownMenus = 17;
        Effect-translucency.MoveResize = 100;
        Effect-translucency.PopupMenus = 18;
        Effect-translucency.TornOffMenus = 19;
        Input.TabletMode = "off";
        Plugins = mkForce {
          blurEnabled = true;
          contrastEnabled = true;
          desktopchangeosdEnabled = false;
          dimscreenEnabled = true;
          forceblurEnabled = true;
          forceblur_x11Enabled = true;
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
          ultrawidewindowsEnabled = false;
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
