{
  pkgs,
  system,
  nixos-conf-editor,
  ...
}:
{

  programs.fzf.enable = true;
  programs.eza.enable = true;
  programs.fd.enable = true;
  programs.lsd.enable = true;
  programs.ripgrep-all.enable = true;
  programs.rclone.enable = true;

  home.packages = (
    with pkgs;
    [
      easyeffects
      lazygit
      nixos-conf-editor.packages.${system}.nixos-conf-editor
      gparted
      layan-gtk-theme
      colloid-icon-theme
      capitaine-cursors
      capitaine-cursors-themed
      fclones-bin
      fortune
      mommy
      clolcat
      #gtk-engines
      #mission-center
      #gtk-engine-murrine
      #xdg-user-dirs-gtk
    ]
  );
  #xorg-xwininfo
  #xone-dongle-firmware
}
