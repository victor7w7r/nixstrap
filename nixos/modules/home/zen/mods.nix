{ config, ... }:
{
  home.file.".zen".source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/zen";
  programs.zen-browser.profiles.default = {
    settings = {
      #"sine.is-cosine" = true;
      "sine.mods-reinstalled" = true;
      "sine.engine.auto-update" = false;

      cmi-Auto-Hide-BookmarkBar = 0;
      cmi-Disable-Better-Context-Menu = false;
      cmi-Grayscale-Extensions-Icons = true;
      cmi-Hide-Bookmark-Element = 0;
      cmi-Padding-Container = "30px";
      cmi-Switch-Gecko-Branch = 1;
      cmi-Switch-Icon-Package = 1;
      cmi-checkmark-margin-left_1 = "6px";
      cmi-checkmark-margin-left_2 = "6px";
      cmi-checkmark-margin-left_cover_1 = "8px";
      cmi-checkmark-margin-left_cover_2 = "6px";
      cmi-checkmark-margin-right_1 = "8px";
      cmi-checkmark-margin-right_2 = "8px";
      cmi-checkmark-margin-right_cover_1 = "10px";
      cmi-checkmark-margin-right_cover_2 = "8px";
      cmi-extension-icon-leftmargin_1 = "0px";
      cmi-extension-icon-leftmargin_2 = "0px";
      cmi-fluentui-icons-leftmargin = "6px";
      cmi-fluentui-text-leftmargin = "8px";
      cmi-fold-item-IDs = "";
      cmi-menu-text-leftmargin_1 = "0px";
      cmi-menu-text-leftmargin_2 = "0px";
      cmi-menuseparator-opacity = "0.5";
      cmi-non-checkmark-subitems-padding_1 = "24px";
      cmi-non-checkmark-subitems-padding_2 = "24px";
      cmi-zenui-icons-leftmargin = "6px";
      cmi-zenui-text-leftmargin = "12px";

      "extensions.quicktabs.commandpalette.dynamic.enabled" = true;
      "extensions.quicktabs.context_menu.access_key" = "";
      "extensions.quicktabs.defaultHeight" = "";
      "extensions.quicktabs.defaultWidth" = "";
      "extensions.quicktabs.initialPosition" = "center";
      "extensions.quicktabs.maxContainers" = "";
      "extensions.quicktabs.taskbar.minWidth" = "";
      "extensions.quicktabs.taskbar.trigger" = "hover";
      "extensions.quicktabs.theme" = "dark";

      "mod.autoexpand.animation_delay" = "0ms";
      "mod.autoexpand.animation_duration" = "10ms";
      "mod.autoexpand.collapse_delay" = "400ms";
      "mod.autoexpand.collapsed_width" = "45px";
      "mod.autoexpand.essential_align" = false;
      "mod.autoexpand.expanded_width" = "100px";
      "mod.autoexpand.fade_sleeping_tabs" = true;
      "mod.autoexpand.hide_workspace_indicator" = true;
      "mod.autoexpand.performance_mode" = "potato";
      "mod.autoexpand.remove_line_separator" = false;

      "mod.forkedtidypopup.hovercolor.dark" = "rgba(87,65,50,255)";
      "mod.forkedtidypopup.hovercolor.light" = "rgba(243,202,176,255)";
      "mod.forkedtidypopup.keepdividers" = true;
      "mod.forkedtidypopup.usecenterbookmarkbar" = true;
      "mod.forkedtidypopup.usecustomhovercolor" = true;
      "mod.forkedtidypopup.usetidyextension" = true;
      "mod.forkedtidypopup.usetidypopup" = true;
      "mod.forkedtidypopup.usezenprimarycolor" = true;

      "mod.superpins.essentials.grid-count" = "1";
      "mod.superpins.pins.active-bg" = "";
      "mod.superpins.pins.grid-count" = "1";

      "mod.zenbettermusicbar.alwaysshow" = true;
      "mod.zenbettermusicbar.custombackground" = "var(--zen-media-control-bg)";
      "mod.zenbettermusicbar.enabled" = true;

      "mod.zencustomurlbar.blur" = "5px";
      "mod.zencustomurlbar.borderradius" = "12px";
      "mod.zencustomurlbar.brightness" = "0.7";
      "mod.zencustomurlbar.customcolor" = "rgba(23, 23, 26, 1)";
      "mod.zencustomurlbar.scale" = "1";
      "mod.zencustomurlbar.transparentvalue" = "15%";
      "mod.zencustomurlbar.useanimation" = true;
      "mod.zencustomurlbar.usefromzen" = true;

      "mod.zentoast.background_opacity" = "0.3";
      "mod.zentoast.border_opacity" = "0.3";
      "mod.zentoast.text_opacity" = "0.3";

      "zen.mods.AudioIndicatorEnhanced.audioWave.colorMuted" =
        "color-mix(in srgb, -moz-dialogtext 50%, rgb(129, 0, 0) 50%)";
      "zen.mods.AudioIndicatorEnhanced.audioWave.colorPlaying" = "-moz-dialogtext";
      "zen.mods.AudioIndicatorEnhanced.audioWave.enabled" = true;
      "zen.mods.AudioIndicatorEnhanced.audioWave.opacity" = "0.2";
      "zen.mods.AudioIndicatorEnhanced.hoverScaleAnimationEnabled" = true;
      "zen.mods.AudioIndicatorEnhanced.returnOldIcons" = true;
      "zen.mods.AudioIndicatorEnhanced.reverseAudioIcons" = false;
      "zen.mods.TabPreviewEnhanced.borderRadiusAmount" = "10px";
      "zen.mods.TabPreviewEnhanced.enabledBackgroundNative" = true;
      "zen.mods.TabPreviewEnhanced.enabledCustomBorderRadius" = true;
      "zen.mods.TabPreviewEnhanced.enabledMargins" = true;

      nebula-active-tab-glow = 0;
      nebula-bookmarks-autohide = 1;
      nebula-default-sound-style = 2;
      nebula-disable-container-styling = true;
      nebula-disable-menu-animations = true;
      nebula-essentials-gray-icons = true;
      nebula-folder-styling = true;
      nebula-glow-gradient = 0;
      nebula-macos-style-buttons = false;
      nebula-nogaps-mod = false;
      nebula-pinned-tabs-bg = false;
      nebula-remove-workspace-indicator = true;
      nebula-tab-loading-animation = 4;
      nebula-tab-switch-animation = 0;
      nebula-tabs-no-shadow = false;
      nebula-turn-off-zen-menu-icon = false;
      nebula-urlbar-animation = 3;
      nebula-workspace-style = 0;

      var-nebula-border-radius = "123px";
      var-nebula-color-glass-dark = "rgba(0, 0, 0, 1)";
      var-nebula-color-glass-light = "rgba(255, 255, 255, 1)";
      var-nebula-color-shadow-dark = "rgba(0, 0, 0, 0.85)";
      var-nebula-color-shadow-light = "rgba(255, 255, 255, 0.855)";
      var-nebula-essentials-width = "60px";
      var-nebula-glass-blur = "320px";
      var-nebula-glass-saturation = "240%";
      var-nebula-tabs-default-dark = "rgba(0,0,0,0.8)";
      var-nebula-tabs-default-light = "rgba(255,255,255,0.8)";
      var-nebula-tabs-hover-dark = "rgba(0,0,0,0.85)";
      var-nebula-tabs-hover-light = "rgba(255,255,255,0.85)";
      var-nebula-tabs-minimum-dark = "rgba(0, 0, 0, 0.8)";
      var-nebula-tabs-minimum-light = "rgba(255, 255, 255, 0.8)";
      var-nebula-tabs-selected-dark = "rgba(0,0,0,0.85)";
      var-nebula-tabs-selected-light = "rgba(255,255,255,0.85)";
      var-nebula-ui-tint-dark = "rgba(0,0,0,0.8)";
      var-nebula-ui-tint-light = "rgba(255,255,255,0.8)";
      var-nebula-website-tint-dark = "rgba(0,0,0,0.8)";
      var-nebula-website-tint-light = "rgba(255,255,255,0)";
      var-nebula-workspace-grayscale = "100%";
    };

    sine = {
      enable = true;
      mods = [
        "context-menu-icons"
        "quick-search-zen-browser"
        "quick-tabs"
        "Nebula"
        "search-engine-select"
        "zen-auto-expand-sidebar"
        "zen-command-palette"
        "zen-drop-link"
        "906c6915-5677-48ff-9bfc-096a02a72379" # Floating Status Bar
        "ae7868dc-1fa1-469e-8b89-a5edf7ab1f24" # Load Bar
        "599a1599-e6ab-4749-ab22-de533860de2c" # Pimp your PiP
        "e51b85e6-cef5-45d4-9fff-6986637974e1" # smaller zen toast popup
        "ad97bb70-0066-4e42-9b5f-173a5e42c6fc" # SuperPins
        "4c2bec61-7f6c-4e5c-bdc6-c9ad1aba1827" # Vertical Split Tab Groups
        "2317fd93-c3ed-4f37-b55a-304c1816819e" # Audio Indicator Enhanced
        "f966100a-4fed-4df5-a082-f001c5bd654e" # Tidy Popup & Extension
        "e9dae25b-2ddd-4245-8581-a6dcf6d35b82" # Zen Custom URL Bar
      ];
    };
  };
}
