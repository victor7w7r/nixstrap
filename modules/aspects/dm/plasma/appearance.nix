{ self, ... }:
{
  den.aspects.plasma.appearance.provides.to-users.homeManager = {
    programs.plasma = {
      workspace = {
        colorScheme = "Layan";
        cursor.theme = "capitaine-cursors";
        enableMiddleClickPaste = false;
        iconTheme = "Colloid-Purple-Catppuccin-Dark";
        theme = "Layan";
        tooltipDelay = 1;
        wallpaper = "/etc/nixos/assets/wallpaper.jpg";
        windowDecorations.library = "org.kde.kwin.aurorae";
        windowDecorations.theme = "__aurorae__svg__Layan";
      };

      configFile.kdeglobals = {
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

      kscreenlocker = {
        appearance = {
          showMediaControls = false;
          wallpaper = "/etc/nixos/assets/wallpaper.jpg";
        };
        autoLock = false;
        timeout = 0;
      };
    };

    home.file.".face.icon".source = "${self}/assets/avatar.png";

    qt = {
      enable = true;
      platformTheme.name = "kvantum";
      style.name = "kvantum-dark";
    };

    xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=LayanDark
    '';
  };
}
