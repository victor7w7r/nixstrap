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
      capitaine-cursors-themed
    ]
  );

  xdg = {
    configFile."mimeapps.list".force = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "zen.desktop";
        "x-scheme-handler/http" = "zen.desktop";
        "x-scheme-handler/https" = "zen.desktop";
        "x-scheme-handler/about" = "zen.desktop";
        "x-scheme-handler/unknown" = "zen.desktop";
        "application/x-extension-htm" = "zen.desktop";
        "application/x-extension-html" = "zen.desktop";
        "application/x-extension-shtml" = "zen.desktop";
        "application/x-extension-xht" = "zen.desktop";
        "application/x-extension-xhtml" = "zen.desktop";
        "application/xhtml+xml" = "zen.desktop";
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
