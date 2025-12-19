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
}
