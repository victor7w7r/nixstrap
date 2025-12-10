{
  pkgs,
  ...
}:
{

  home.packages = (
    with pkgs;
    [
      layan-gtk-theme
      colloid-icon-theme
      capitaine-cursors
      capitaine-cursors-themed
      #gtk-engines
      #https://github.com/debasish-patra-1987/linuxthemestore
      #gtk-engine-murrine
      #xdg-user-dirs-gtk
    ]
  );

  programs.pywal.enable = true;
}
