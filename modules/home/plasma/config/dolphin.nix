{ ... }:
{
  programs.plasma.configFile = {
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
      "KFileDialog Settings" = {
        "Places Icons Auto-resize" = false;
        "Places Icons Static Size" = 22;
      };
      "Notification Messages".warnAboutRisksBeforeActingAsAdmin = false;
      PreviewSettings.Plugins = "appimagethumbnail,cursorthumbnail,mobithumbnail,audiothumbnail,textthumbnail,fontthumbnail,ffmpegthumbs,djvuthumbnail,gsthumbnail,rawthumbnail,directorythumbnail,kraorathumbnail,opendocumentthumbnail,windowsexethumbnail,avif,glycin-heif,heif,glycin-image-rs,glycin-jxl,jxl,librsvg,glycin-svg,imagethumbnail,windowsimagethumbnail,exrthumbnail,jpegthumbnail,svgthumbnail,comicbookthumbnail,ebookthumbnail,exe-thumbnailer";
    };
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
  };
}
