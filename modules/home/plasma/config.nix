{ ... }:
{
  programs.plasma = {
    enable = true;
    configFile = {
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
        "Libinput/0/0/DP-3".PointerAccelerationProfile = 1;
        "Libinput/1241/41119/E-Signal USB Gaming Mouse".PointerAccelerationProfile = 1;
        "Libinput/1386/38/Wacom Intuos5 touch S (WL) Finger".NaturalScroll = true;
        "Libinput/1386/38/Wacom Intuos5 touch S (WL) Finger".PointerAccelerationProfile = 1;
        "Libinput/1386/38/Wacom Intuos5 touch S (WL) Finger".TapAndDrag = false;
        "Libinput/1386/38/Wacom Intuos5 touch S (WL) Pen".MapToWorkspace = true;
        "Libinput/1386/38/Wacom Intuos5 touch S Finger".NaturalScroll = true;
        "Libinput/1386/38/Wacom Intuos5 touch S Finger".PointerAccelerationProfile = 1;
        "Libinput/1386/38/Wacom Intuos5 touch S Pen".MapToWorkspace = true;
        "Libinput/1739/33391/SYNA3081:00 06CB:826F Mouse".PointerAcceleration = "-1.000";
        "Libinput/1739/33391/SYNA3081:00 06CB:826F Mouse".PointerAccelerationProfile = 1;
        "Libinput/1739/33391/SYNA3081:00 06CB:826F Mouse".ScrollFactor = 0.1;
        "Libinput/9011/26214/ydotoold virtual device".PointerAccelerationProfile = 1;
        Mouse.X11LibInputXAccelProfileFlat = true;
        Mouse.cursorTheme = "capitaine-cursors";
      };
      kded5rc.Module-device_automounter.autoload = false;
      kdeglobals = {
        General = {
          TerminalApplication = "wezterm";
          TerminalService = "wezterm.desktop";
          XftHintStyle = "hintslight";
          XftSubPixel = "none";
          fixed = "JetBrainsMonoNL Nerd Font Mono,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
          font = "Ubuntu,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
          menuFont = "Ubuntu,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
          smallestReadableFont = "Ubuntu,8,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
          toolBarFont = "Ubuntu,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
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
          "Show Full Path" = false;
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
        PreviewSettings = {
          EnableRemoteFolderThumbnail = false;
          PreviewSettings.MaximumRemoteSize = 0;
        };
        WM = {
          activeBackground = "54,56,62";
          activeBlend = "59,62,68";
          activeFont = "Ubuntu,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
          activeForeground = "221,221,221";
          inactiveBackground = "62,65,71";
          inactiveBlend = "67,71,77";
          inactiveForeground = "120,120,120";
        };
      };
      kgammarc.ConfigFile.use = "kgammarc";
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
        Effect-blur.BlurStrength = 5;
        Effect-blur.NoiseStrength = 2;
        Effect-blurplus.BlurDecorations = true;
        Effect-blurplus.BlurDocks = true;
        Effect-blurplus.WindowClasses = "dolphin\norg.wezfurlong.wezterm";
        Effect-overview.OrganizedGrid = false;
        Effect-translucency.DropdownMenus = 17;
        Effect-translucency.MoveResize = 100;
        Effect-translucency.PopupMenus = 18;
        Effect-translucency.TornOffMenus = 19;
        Effect-zoom.InitialZoom = 1.3410667881629732;
        Input.TabletMode = "off";
        NightColor.Active = true;
        NightColor.DayTemperature = 3600;
        NightColor.Mode = "Constant";
        NightColor.NightTemperature = 4300;
        Plugins.blurEnabled = true;
        Plugins.contrastEnabled = true;
        Plugins.desktopchangeosdEnabled = false;
        Plugins.dimscreenEnabled = true;
        Plugins.forceblurEnabled = true;
        Plugins.forceblur_x11Enabled = true;
        Plugins.fullscreenifyEnabled = false;
        Plugins.kzonesEnabled = true;
        Plugins.macsimize6Enabled = false;
        Plugins.minimizeallEnabled = true;
        Plugins.mousemarkEnabled = true;
        Plugins.screenedgeEnabled = false;
        Plugins.sticky-window-snappingEnabled = true;
        Plugins.temporary-virtual-desktopsEnabled = false;
        Plugins.translucencyEnabled = true;
        Plugins.truely-maximizedEnabled = true;
        Plugins.ultrawidewindowsEnabled = false;
        Plugins.virtual-desktops-only-on-primaryEnabled = true;
        Plugins.zoomEnabled = false;
        TabBox.HighlightWindows = false;
        TabBox.LayoutName = "thumbnail_grid";
        TabBoxAlternative.ActivitiesMode = 0;
        TabBoxAlternative.DesktopMode = 0;
        TabBoxAlternative.MultiScreenMode = 1;
        Tiling.padding = 4;
        Wayland.EnablePrimarySelection = false;
        Windows.BorderlessMaximizedWindows = true;
        Xwayland.Scale = 1;
        "org.kde.kdecoration2".ButtonsOnLeft = "XIA";
        "org.kde.kdecoration2".ButtonsOnRight = "F";
      };
      kxkbrc.Layout = {
        DisplayNames = ",lat";
        LayoutList = "us,latam";
        Options = "caps:ctrl_modifier";
        ResetOldOptions = true;
        Use = true;
        VariantList = ",";
      };
      plasma-localerc.Formats.LANG = "es_ES.UTF-8";
      plasmanotifyrc = {
        "Applications/motrix".Seen = true;
        "Applications/org.kde.konsole".ShowBadges = false;
        "Applications/org.kde.konsole".ShowInHistory = false;
        "Applications/org.kde.konsole".ShowPopups = false;
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
      spectaclerc.Annotations.annotationToolType = 2;
    };
  };
}
