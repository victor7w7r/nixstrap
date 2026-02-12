{ ... }:
{
  programs.plasma.panels = [
    {
      location = "bottom";
      alignment = "center";
      lengthMode = "fit";
      floating = true;
      height = 44;
      hiding = "none";
      #hiding = "autohide";
      screen = 0;
      opacity = "translucent";
      widgets = [
        {
          name = "p-connor.plasma-drawer";
          config = {
            General = {
              appIconSize = 64;
              customButtonImage = "com.system76.CosmicLauncher";
              disableAnimations = true;
              favoriteSystemActions = [
                "shutdown"
                "reboot"
                "logout"
                "suspend"
                "lock-screen"
                "switch-user"
              ];
              maxNumberColumns = 12;
              searchRunners = [
                "krunner_services"
                "krunner_recentdocuments"
                "baloosearch"
              ];
              showSystemActions = false;
              systemActionIconSize = 32;
              useCustomButtonImage = true;
              useSymbolicSystemActionIcons = true;
            };
          };
        }
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
              "applications:zen-beta.desktop"
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
          name = "org.51n7.kMenu";
          config = {
            PreloadWeight = 100;
            popupHeight = 319;
            popupWidth = 240;
            Appearance = {
              cmdList = [
                "kinfocenter"
                "separator"
                "systemsettings"
                "missioncenter"
                "separator"
                "systemctl suspend -f"
                "systemctl reboot"
                "systemctl reboot --firmware-setup"
                "systemctl poweroff"
                "separator"
                "qdbus org.freedesktop.ScreenSaver /ScreenSaver Lock"
                "qdbus org.kde.LogoutPrompt /LogoutPrompt promptLogout"
              ];
              icon = "/etc/nixos/logo.svg";
              iconList = [
                "help-hint"
                "filename-dash-amarok"
                "settings-configure"
                "view-process-all-tree"
                "update-none"
                "filename-dash-amarok"
                "system-suspend"
                "system-reboot"
                "system-reboot-symbolic"
                "system-shutdown"
                "filename-dash-amarok"
                "system-lock-screen"
                "system-log-out"
              ];
              labelList = [
                "Acerca De Esta PC..."
                "separator"
                "Configuración del Sistema..."
                "Administrador de Tareas..."
                "separator"
                "Reposo"
                "Reiniciar"
                "Reiniciar a UEFI"
                "Apagar"
                "separator"
                "Bloquear"
                "Cerrar Sesión"
              ];
              separatorList = [
                false
                true
                false
                false
                true
                false
                false
                false
                false
                true
                false
                false
              ];
            };
            ConfigDialog = {
              DialogHeight = 540;
              DialogWidth = 720;
            };
          };
        }
        {
          name = "com.github.antroids.application-title-bar";
          config = {
            Appearance = {
              overrideElementsMaximized = true;
              widgetButtonsAnimation = 0;
              widgetButtonsAuroraeTheme = "Layan";
              widgetButtonsIconsTheme = "Aurorae";
              widgetButtonsMargins = 9;
              widgetElements = "windowTitle";
              widgetElementsDisabledMode = "HideKeepSpace";
              widgetElementsMaximized = [
                "spacer"
                "windowCloseButton"
                "spacer"
                "windowMinimizeButton"
                "spacer"
                "windowMaximizeButton"
                "windowTitle"
              ];
              windowTitleFontSize = 9;
              windowTitleFontSizeMode = "VerticalFit";
              windowTitleHideEmpty = true;
              windowTitleMarginsLeft = 14;
              windowTitleMarginsRight = 3;
              windowTitleMarginsTop = 2;
              windowTitleSource = "AppName";
              windowTitleSourceMaximized = "AppName";
              windowTitleUndefined = "";
            };
            ConfigDialog = {
              DialogHeight = 540;
              DialogWidth = 720;
            };
          };
        }
        {
          name = "org.kde.plasma.appmenu";
          config = {
            immutability = 1;
            ConfigDialog = {
              DialogHeight = 540;
              DialogWidth = 720;
            };
          };
        }
        "org.kde.plasma.panelspacer"
        {
          name = "org.kde.plasma.systemmonitor.memory";
          config = {
            CurrentPreset = "org.kde.plasma.systemmonitor";
            Appearance = {
              chartFace = "org.kde.ksysguard.piechart";
              title = "Memoria";
            };
            SensorColors."memory/physical/usedPercent" = "86,245,178";
            Sensors = {
              highPrioritySensorIds = [ "memory/physical/usedPercent" ];
              lowPrioritySensorIds = [
                "memory/physical/total"
                "memory/swap/usedPercent"
                "memory/swap/total"
              ];
              totalSensors = [ "memory/physical/usedPercent" ];
            };
          };
        }

        {
          systemTray = {
            icons.scaleToFit = true;
            items = {
              showAll = false;
              shown = [
                "org.kde.plasma.battery"
                "org.kde.plasma.clipboard"
                "org.kde.plasma.keyboardlayout"
                "org.kde.plasma.notifications"
                "org.kde.plasma.networkmanagement"
                "org.kde.plasma.volume"
              ];
              hidden = [
                "org.kde.merkuro.contact.applet"
                "org.kde.plasma.bluetooth"
                "org.kde.plasma.brightness"
                "org.kde.plasma.devicenotifier"
                "org.kde.plasma.mediacontroller"
                "org.kde.plasma.vault"
                "plasmashell_microphone"
                "xdg-desktop-portal-kde"
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
          name = "KdeControlStation";
          config = {
            Appearance = {
              brightness_widget_flat = true;
              brightness_widget_thin = true;
              brightness_widget_title = false;
              layout = 2;
              showCmd1 = true;
              showCmd2 = true;
              showColorSwitcher = false;
              showNightLight = false;
              showPercentage = true;
              showSessionActions = false;
              transparency = true;
              usePlasmaSliders = true;
              volume_widget_flat = true;
              volume_widget_thin = true;
              volume_widget_title = false;
            };
          };
        }
        {
          digitalClock = {
            time = {
              showSeconds = "onlyInTooltip";
              format = "12h";
            };
            date = {
              enable = true;
              format.custom = "ddd.   dd/MM";
              position = "belowTime";
            };
            calendar.firstDayOfWeek = "monday";
          };
        }
      ];
    }
  ];
}
