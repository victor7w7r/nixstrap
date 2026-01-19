{ pkgs, ... }:
{
  gtk = {
    enable = true;
    cursorTheme = {
      package = pkgs.capitaine-cursors;
      theme = "capitaine-cursors";
      size = 24;
    };
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
    gtk2.extraConfig = "
				gtk-primary-button-wraps-slider = 1
				gtk-toolbar-style = 3
				gtk-menu-images = 1
				gtk-button-images = 1
				gtk-enable-mnemonics = 0
			";

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-button-images = true;
      gtk-menu-images = true;
      gtk-toolbar-style = 3;
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };

  qt.enable = false;
  xfconf.settings = {
    xsettings = {
      "Gtk/MonospaceFontName" = "UbuntuMono Nerd Font 11";
      "Gtk/FontName" = "Ubuntu Nerd Font 10";
      "Net/IconThemeName" = "Colloid-Purple-Catppuccin-Dark";
      "Net/ThemeName" = "Layan-Dark";
    };
    xfwm4 = {
      "general/theme" = "Layan-Dark";
    };
    xfce4-power-manager = {
      "lid-action-on-ac" = 1;
      "lock-screen-suspend-hibernate" = false;
    };
    xfce4-desktop = {
      "desktop-icons/style" = 1;
    };
  };
}
