{ host, ... }:
{
  #https://github.com/DocBrown101/org.kde.plasma.nixos.channelstatus
  programs.plasma.panels = [
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
            popupHeight = 309;
            popupWidth = 240;
            General = {
              customButtonImage = "/home/victor7w7r/.cache/logo.svg";
              useCustomButtonImage = true;
              menuJson = ''[  {    "name": "Acerca De Esta PC...",    "icon": "help-hint",    "command": "kinfocenter"  },  {    "separator": true  },  {    "name": "Ajustes...",    "icon": "settings-configure",    "command": "systemsettings"  },  {    "name": "Monitor de recursos",    "icon": "settings-configure",    "command": "missioncenter"  },  {    "separator": true  },  {    "name": "Reposo",    "icon": "system-suspend",    "command": "systemctl suspend -f"  },  {    "name": "Hibernar",    "icon": "system-suspend",    "command": "systemctl hibernate"  },   {    "name": "Reiniciar",    "icon": "system-reboot",    "command": "systemctl reboot"  },  {    "name": "Reiniciar a UEFI",    "icon": "system-reboot",    "command": "systemctl reboot --firmware-setup"  },  {    "name": "Apagar...",    "icon": "system-shutdown",    "command": "qdbus org.kde.LogoutPrompt /LogoutPrompt promptShutDown"  },  {    "separator": true  },  {    "name": "Bloquear",    "icon": "system-lock-screen",    "command": "qdbus org.freedesktop.ScreenSaver /ScreenSaver Lock"  },  {    "name": "Cerrar Sesión",    "icon": "system-log-out",    "command": "qdbus org.kde.LogoutPrompt /LogoutPrompt promptLogout"  }]'';
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
          name = "org.kde.plasma.systemmonitor";
          config =
            let
              fan = if host == "v7w7r-macmini81" then "lmsensors/applesmc-acpi-0" else "";
            in
            {
              CurrentPreset = "org.kde.plasma.systemmonitor";
              PreloadWeight = 75;
              popupHeight = 124;
              popupWidth = 230;
              ConfigDialog = {
                DialogHeight = 538;
                DialogWidth = 720;
              };
              Appearance = {
                chartFace = "org.kde.ksysguard.piechart";
                showTitle = true;
                title = "Ventilador";
              };
              Sensors."highPrioritySensorIds" = ''["${fan}/fan1"]'';
              Sensors."totalSensors" = ''["${fan}/fan1"]'';
              SensorColors."${fan}/temp1" = "245,161,86";
              "org.kde.ksysguard.piechart/General" = {
                rangeTo = 4500;
                rangeAuto = false;
              };
            };
        }
        {
          name = "org.kde.plasma.systemmonitor.memory";
          config = {
            CurrentPreset = "org.kde.plasma.systemmonitor";
            PreloadWeight = 100;
            popupHeight = 203;
            popupWidth = 150;
            ConfigDialog = {
              DialogHeight = 540;
              DialogWidth = 720;
            };
            Appearance = {
              chartFace = "org.kde.ksysguard.piechart";
              showTitle = true;
              title = "Memoria";
            };
            Sensors."highPrioritySensorIds" = ''["memory/physical/usedPercent"]'';
            Sensors."lowPrioritySensorIds" =
              ''["memory/physical/total","memory/swap/usedPercent","memory/swap/total"]'';
            Sensors."totalSensors" = ''["memory/physical/usedPercent"]'';
            SensorColors."memory/physical/usedPercent" = "86,245,178";
          };
        }
        {
          name = "org.kde.plasma.systemmonitor.cpucore";
          config = {
            CurrentPreset = "org.kde.plasma.systemmonitor";
            PreloadWeight = 100;
            popupHeight = 374;
            popupWidth = 374;
            ConfigDialog = {
              DialogHeight = 540;
              DialogWidth = 720;
            };
            Appearance = {
              chartFace = "org.kde.ksysguard.piechart";
              title = "CPU";
              updateRateLimit = 2000;
            };
            SensorColors."cpu/all/usage" = "245,86,99";
            Sensors."highPrioritySensorIds" = ''["cpu/all/usage"]'';
            Sensors."lowPrioritySensorIds" = ''["cpu/cpu.*usage" ]'';
            Sensors."totalSensors" = ''["cpu/all/usage" ]'';
          };
        }
        {
          name = "org.kde.plasma.systemmonitor.cpucore";
          config = {
            CurrentPreset = "org.kde.plasma.systemmonitor";
            ConfigDialog = {
              DialogHeight = 522;
              DialogWidth = 720;
            };
            popupHeight = 393;
            popupWidth = 381;
            Appearance = {
              chartFace = "org.kde.ksysguard.piechart";
              title = "Temperatura";
              updateRateLimit = 2000;
            };

            Sensors."highPrioritySensorIds" = ''["cpu/all/averageTemperature"]'';
            Sensors."totalSensors" = ''["cpu/all/averageTemperature"]'';
            SensorColors."cpu/cpu.*/usage" = "86,87,245";
            "org.kde.ksysguard.piechart/General" = {
              rangeTo = 100;
              rangeAuto = false;
            };
          };
        }
        {
          name = "org.kde.plasma.systemtray";
          config.General = {
            scaleIconsToFit = true;
            showAllItems = false;
            spacing = 2;
            shownItems = [
              "org.kde.plasma.keyboardlayout"
              "org.kde.plasma.notifications"
              "org.kde.plasma.networkmanagement"
              "org.kde.plasma.volume"
            ]
            ++ (
              if host != "v7w7r-macmini81" then
                [
                  "org.kde.plasma.battery"
                ]
              else
                [ ]
            );
            hiddenItems = [
              "org.kde.plasma.bluetooth"
              "org.kde.plasma.clipboard"
              "org.kde.plasma.devicenotifier"
              "org.kde.plasma.manage-inputmethod"
              "org.kde.plasma.mediacontroller"
              "org.kde.plasma.notifications"
              "org.kde.plasma.keyboardindicator"
              "org.kde.plasma.keyboardlayout"
              "org.kde.plasma.networkmanagement"
              "org.kde.plasma.volume"
              "org.kde.plasma.vault"
              "org.kde.kdeconnect"
              "org.kde.kscreen"
              "org.kde.plasma.printmanager"
              "org.kde.plasma.brightness"
              "org.kde.plasma.cameraindicator"
              "com.github.wwmm.easyeffects"
            ];
            #knownItems = extraItems;
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
              format.custom = "ddd. dd/MM";
              position = "belowTime";
            };
            calendar.firstDayOfWeek = "monday";
          };
        }
      ];
    }
  ];
}
