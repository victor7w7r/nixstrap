{ ... }:
{
  programs.plasma.configFile = {
    dolphinrc = {
      ContentDisplay.UsePermissionsFormat = "NumericFormat";
      ContextMenu = {
        ShowOpenInNewTab = true;
        ShowOpenInNewWindow = true;
        ShowOpenTerminal = true;
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
        InformationPanelVisible = true;
        OpenNewTabAfterLastTab = true;
        ShowFullPath = true;
        ShowStatusBar = "FullWidth";
        ShowToolTips = true;
        ShowZoomSlider = true;
        UseTabForSwitchingSplitView = true;
        Version = 202;
        ViewPropsTimestamp = "2026,4,8,6,53,20.3";
      };
      InformationPanel.dateFormat = "ShortFormat";
      "KFileDialog Settings" = {
        "Places Icons Auto-resize" = false;
        "Places Icons Static Size" = 22;
      };
      "Notification Messages".warnAboutRisksBeforeActingAsAdmin = false;
      PreviewSettings.Plugins = "appimagethumbnail,cursorthumbnail,mobithumbnail,audiothumbnail,textthumbnail,fontthumbnail,ffmpegthumbs,djvuthumbnail,gsthumbnail,rawthumbnail,directorythumbnail,kraorathumbnail,opendocumentthumbnail,windowsexethumbnail,avif,glycin-heif,heif,glycin-image-rs,glycin-jxl,jxl,librsvg,glycin-svg,imagethumbnail,windowsimagethumbnail,exrthumbnail,jpegthumbnail,svgthumbnail,comicbookthumbnail,ebookthumbnail,exe-thumbnailer";
    };
    kiorc = {
      Confirmations = {
        ConfirmDelete = false;
        ConfirmEmptyTrash = false;
        ConfirmTrash = false;
      };
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
    ktrashrc."\\/home\\/victor7w7r\\/.local\\/share\\/Trash" = {
      Days = 7;
      LimitReachedAction = 0;
      Percent = 10;
      UseSizeLimit = true;
      UseTimeLimit = false;
    };
  };
}
