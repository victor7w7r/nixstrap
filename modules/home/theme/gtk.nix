{ pkgs, ... }:

{
  gtk = {
    #appmenu-gtk-module
    enable = true;
    iconTheme = {
      name = "Colloid-Purple-Catppuccin-Dark";
      package = (
        pkgs.colloid-icon-theme.override {
          schemeVariants = [ "catppuccin" ];
          colorVariants = [ "purple" ];
        }
      );
    };
    theme = {
      name = "Layan-Dark";
      package = pkgs.layan-gtk-theme;
    };
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };
}
