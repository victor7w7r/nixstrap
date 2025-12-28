{ lib, ... }:
{
  programs.plasma = {
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
    configFile.kwinrc = {
      Effect-blurplus.BlurDecorations = true;
      Effect-blurplus.BlurDocks = true;
      Effect-blurplus.WindowClasses = "dolphin\norg.wezfurlong.wezterm";
      Effect-overview.OrganizedGrid = false;
      Effect-translucency.DropdownMenus = 17;
      Effect-translucency.MoveResize = 100;
      Effect-translucency.PopupMenus = 18;
      Effect-translucency.TornOffMenus = 19;
      Input.TabletMode = "off";
      Plugins = lib.mkForce {
        blurEnabled = true;
        contrastEnabled = true;
        desktopchangeosdEnabled = false;
        dimscreenEnabled = true;
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
  };
}
