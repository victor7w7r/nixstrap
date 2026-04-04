{ config, pkgs, ... }:
{
  home.packages = (
    with pkgs;
    [
      layan-gtk-theme
      (pkgs.colloid-icon-theme.override {
        schemeVariants = [ "catppuccin" ];
        colorVariants = [ "purple" ];
      })
      capitaine-cursors
    ]
  );

  xdg = {
    configFile."mimeapps.list".force = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = [ "zen-beta.desktop" ];
        "video/png" = [ "vlc.desktop" ];
        "video/jpg" = [ "vlc.desktop" ];
        "video/*" = [ "vlc.desktop" ];
        "x-scheme-handler/http" = [ "zen-beta.desktop" ];
        "x-scheme-handler/chrome" = [ "zen-beta.desktop" ];
        "x-scheme-handler/https" = [ "zen-beta.desktop" ];
        "text/html" = [ "zed.desktop" ];
        "application/x-extension-htm" = [ "zed.desktop" ];
        "application/x-extension-html" = [ "zed.desktop" ];
        "application/x-extension-shtml" = [ "zed.desktop" ];
        "application/xhtml+xml" = [ "zed.desktop" ];
        "application/x-extension-xhtml" = [ "zed.desktop" ];
        "application/x-extension-xht" = [ "zed.desktop" ];
      };
    };
    userDirs = {
      desktop = "${config.home.homeDirectory}/tmp";
      download = "${config.home.homeDirectory}/tmp";
      documents = "${config.home.homeDirectory}/files";
      music = "${config.home.homeDirectory}/files/media";
      pictures = "${config.home.homeDirectory}/files/media";
      videos = "${config.home.homeDirectory}/files/media";
    };
  };
}
