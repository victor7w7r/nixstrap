{
  flake-file.inputs.nixpkgs-gtk2.url = "github:NixOS/nixpkgs/48199e04590301db3a47603919037df65c828797";

  den.aspects.gui.gtk.provides.to-users.homeManager =
    { inputs', pkgs, ... }:
    {
      gtk = {
        enable = true;
        font = {
          name = "JetBrainsMono Nerd Font";
          size = 11;
        };
        cursorTheme = {
          package = pkgs.capitaine-cursors;
          name = "capitaine-cursors";
          size = 24;
        };
        iconTheme = {
          name = "Colloid-Purple-Catppuccin-Dark";
          package = pkgs.colloid-icon-theme.override {
            schemeVariants = [ "catppuccin" ];
            colorVariants = [ "purple" ];
          };
        };
        theme = {
          name = "Layan-Dark";
          package = inputs'.nixpkgs-gtk2.legacyPackages.layan-gtk-theme;
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
        gtk4.extraConfig.Settings = "gtk-application-prefer-dark-theme=1";
      };

      home.packages = with pkgs; [
        dconf
        inputs'.nixpkgs-gtk2.legacyPackages.gtk-engine-murrine
        inputs'.nixpkgs-gtk2.legacyPackages.layan-gtk-theme
        (colloid-icon-theme.override {
          schemeVariants = [ "catppuccin" ];
          colorVariants = [ "purple" ];
        })
        capitaine-cursors
        capitaine-cursors-themed
      ];
    };
}
