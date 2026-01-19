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
    mimeApps.enable = true;
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
