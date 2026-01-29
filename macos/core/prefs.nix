{ ... }:
{
  system = {
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };

    nvram.variables.StartupMute = "%01";
    #sudo nvram boot-args="serverperfmode=1 $(nvram boot-args 2>/dev/null | cut -f 2-)"
    #sudo nvram boot-args="cpus=4"

    defaults = {
      ActivityMonitor = {
        IconType = 5;
        OpenMainWindow = true;
        ShowCategory = 100;
        SortColumn = "CPUUsage";
        SortDirection = 0;
      };

      CustomUserPreferences = {
        "com.apple.Accessibility" = {
          DifferentiateWithoutColor = 1;
          EnhancedBackgroundContrastEnabled = 1;
          ReduceMotionEnabled = 1;
        };

        "com.apple.assistant.support"."Assistant Enabled" = false;

        "com.apple.commerce" = {
          AutoUpdate = false;
          AutoUpdateRestartRequired = false;
        };

        "com.apple.CrashReporter".DialogType = "none";
        "com.apple.desktopservices" = {
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
          UseBareEnumeration = true;
        };

        "com.apple.dt.Xcode" = {
          BuildSystemScheduleInherentlyParallelCommandsExclusively = "YES";
          ShowBuildOperationDuration = "YES";
          XcodeCloudUpsellPromptEnabled = false;
        };

        "com.apple.DiskUtility" = {
          advanced-image-options = true;
          DUDebugMenuEnabled = true;
        };

        "com.apple.dock" = {
          showAppExposeGestureEnabled = true;
          workspaces-auto-swoosh = true;
          wvous-bl-modifier = 0;
          wvous-br-modifier = 0;
          wvous-tl-modifier = 0;
          wvous-tr-modifier = 0;
        };

        "com.apple.finder" = {
          DisableAllAnimations = true;
          _FXSortFoldersFirst = true;
          FXEnableRemoveFromICloudDriveWarning = false;
          FK_StandardViewSettings = {
            IconViewSettings = {
              arrangeBy = "grid";
              gridSpacing = 1.0;
              iconSize = 64.0;
              showItemInfo = true;
            };
          };
          FXInfoPanesExpanded = {
            General = true;
            MetaData = false;
            Name = true;
            OpenWith = true;
            Preview = false;
            Privileges = false;
          };
          NewWindowTarget = "PfHm";
          NewWindowTargetIsHome = true;
          NewWindowTargetPath = "";
          OpenWindowForNewRemovableDisk = true;
          QLEnableTextSelection = true;
          ShowExternalHardDrivesOnDesktop = true;
          ShowHardDrivesOnDesktop = true;
          ShowMountedServersOnDesktop = true;
          ShowRecentTags = false;
          ShowRemovableMediaOnDesktop = true;
          WarnOnEmptyTrash = false;
        };

        "com.apple.frameworks.diskimages" = {
          auto-open-ro-root = false;
          auto-open-rw-root = false;
          skip-verify = true;
          skip-verify-locked = true;
          skip-verify-remote = true;
        };

        "com.apple.NetworkBrowser".BrowseAllInterfaces = true;
        "com.apple.PowerChime".ChimeOnAllHardware = false;
        "com.apple.ScriptEditor2".ApplePersistence = false;

        "com.apple.Siri" = {
          StatusMenuVisible = false;
          VoiceTriggerUserEnabled = false;
        };

        "com.apple.security.authorization".ignoreArd = true;
        "com.apple.SoftwareUpdate" = {
          AutomaticCheckEnabled = false;
          AutomaticDownload = 0;
          ConfigDataInstall = 0;
          CriticalUpdateInstall = 1;
          ScheduleFrequency = 0;
        };

        "com.apple.systempreferences".NSQuitAlwaysKeepsWindows = false;

        "com.apple.WindowManager" = {
          EnableStandardClickToShowDesktop = false;
          StandardHideDesktopIcons = false;
          HideDesktop = false;
          StageManagerHideWidgets = false;
          AutoHide = false;
        };

        "com.apple.systemuiserver" = {
          "NSStatusItem Visible com.apple.menuextra.appleuser" = false;
          "NSStatusItem Visible com.apple.menuextra.bluetooth" = false;
          "NSStatusItem Visible com.apple.menuextra.clock" = false;
          "NSStatusItem Visible com.apple.menuextra.volume" = false;
          dontAutoLoad = [
            "/System/Library/CoreServices/Menu Extras/AirPort.menu"
            "/System/Library/CoreServices/Menu Extras/VPN.menu"
            "/System/Library/CoreServices/Menu Extras/WWAN.menu"
          ];
        };

        "com.apple.TextInputMenu".visible = false;
        ".GlobalPreferences" = {
          MultipleSessionsEnabled = true;
        };

        NSGlobalDomain = {
          AppleEnableMenuBarTransparency = false;
          AppleLanguages = [ "es-ES" ];
          AppleLocale = "es_ES@currency=USD";
          CGFontRenderingFontSmoothingDisabled = false;
          NSAllowContinuousSpellChecking = false;
          NSAutomaticWindowAnimationsEnabled = false;
          NSDisableAutomaticTermination = true;
          NSQuitAlwaysKeepsWindows = false;
        };
      };

      CustomSystemPreferences = {
        "/Library/Preferences/com.apple.windowserver".DisplayResolutionEnabled = true;
        "/Library/Preferences/com.apple.security.libraryvalidation".DisableLibraryValidation = true;
        "'/Library/Application Support/CrashReporter/DiagnosticMessagesHistory'" = {
          AutoSubmit = false;
          SeedAutoSubmit = false;
          AutoSubmitVersion = 4;
          ThirdPartyDataSubmit = false;
          ThirdPartyDataSubmitVersion = 4;
        };

        loginwindow = {
          AllowList = "*";
          autoLoginUser = true;
          DisableScreenLock = true;
          DisableConsoleAccess = true;
          GuestEnabled = false;
          PowerOffDisabledWhileLoggedIn = false;
          RestartDisabledWhileLoggedIn = false;
          ShutDownDisabledWhileLoggedIn = false;
          TALLogoutSavesState = false;
        };
      };

      dock = {
        autohide = true;
        autohide-delay = 0.0;
        autohide-time-modifier = 0.0;
        dashboard-in-overlay = true;
        enable-spring-load-actions-on-all-items = true;
        expose-animation-duration = 0.001;
        hide-mirror = true;
        launchanim = false;
        magnification = false;
        mineffect = "scale";
        mru-spaces = false;
        no-glass = true;
        orientation = "bottom";
        showhidden = true;
        show-recents = false;
        show-process-indicators = true;
        springboard-hide-duration = 0.0;
        springboard-page-duration = 0.0;
        static-only = false;
        tilesize = 50;
        workspaces-edge-delay = 0;
        workspaces-swoosh-animation-off = true;
        wvous-bl-corner = null;
        wvous-br-corner = null;
        wvous-tl-corner = null;
        wvous-tr-corner = null;
      };

      finder = {
        AnimateInfoPanes = false;
        AnimateSnapToGrid = false;
        DisableAllAnimations = true;
        EmptyTrashSecurely = true;
        FXDefaultSearchScope = "SCcf";
        FXEnableExtensionChangeWarning = false;
        FXEnableSlowAnimation = false;
        FXInfoPanesExpanded = {
          General = true;
          OpenWith = true;
          Privileges = true;
        };
        FXPreferredGroupBy = "Name";
        FXPreferredViewStyle = "icnv";
        _FXShowPosixPathInTitle = true;
        OpenWindowForNewRemovableDisk = false;
        QLEnableTextSelection = true;
        QLEnableSlowMotion = false;
        ShowStatusBar = true;
        ShowPathbar = true;
      };

      iphonesimulator.AllowFullscreenMode = "YES";

      LaunchServices.LSQuarantine = false;

      menuextra.battery.ShowTime = "YES";
      NetworkBrowser.BrowseAllInterfaces = true;
      NSNavPanelExpandedStateForSaveMode = true;
      NSGlobalDomain = {
        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.springing.enabled" = true;
        "com.apple.springing.delay" = 0.3;
        "com.apple.sound.beep.feedback" = 0;
        "com.apple.sound.beep.volume" = 0.000;
        AppleFontSmoothing = 0;
        AppleInterfaceStyle = "Dark";
        AppleInterfaceStyleSwitchesAutomatically = false;
        AppleKeyboardUIMode = 3;
        AppleMetricUnits = 1;
        AppleMeasurementUnits = "Centimeters";
        ApplePressAndHoldEnabled = false;
        AppleScrollerPagingBehavior = true;
        AppleShowAllExtensions = true;
        AppleShowScrollBars = "Always";
        AppleWindowTabbingMode = "always";
        InitialKeyRepeat = 15;
        KeyRepeat = 4;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticWindowAnimationsEnabled = false;
        NSDisableAutomaticTermination = true;
        NSDocumentSaveNewDocumentsToCloud = false;
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
        NSTextShowsControlCharacters = true;
        NSPersonNameDefaultDisplayNameOrder = 1;
        NSScrollAnimationEnabled = true;
        NSTableViewDefaultSizeMode = 1;
        NSUseAnimatedFocusRing = false;
        NSWindowResizeTime = 0.001;
        NSWindowShouldDragOnGesture = true;
      };
      screencapture.disable-shadow = true;

      universalaccess = {
        reduceMotion = 1;
        reduceTransparency = true;
      };

      WindowManager = {
        AppWindowGroupingBehavior = false;
        EnableTiledWindowMargins = false;
        GloballyEnabled = true;
      };
    };
  };
}
