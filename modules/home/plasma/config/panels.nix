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
        /*
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
        */
        {
          name = "org.51n7.kMenu";
        }
        {
          name = "com.github.antroids.application-title-bar";
        }
        {
          name = "org.kde.plasma.appmenu";
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
          name = "KdeControlStation";
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
