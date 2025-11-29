{ inputs, pkgs, ... }:
{
  home.packages = (with pkgs; [
    easyeffects
    lazygit
    gparted

    layan-gtk-theme
    colloid-icon-theme
    capitaine-cursors
    capitaine-cursors-themed
  ]);
}