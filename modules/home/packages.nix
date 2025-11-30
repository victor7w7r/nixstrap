{ pkgs, ... }:
{
  home.packages = (
    with pkgs;
    [
      easyeffects
      lazygit
      gparted

      layan-gtk-theme
      colloid-icon-theme
      capitaine-cursors
      capitaine-cursors-themed

      #bottles
      #dosbox
      #goverlay
      #vkbasalt
      #inotify-tools
      #nyrna
      #protonup-qt
      #umu-launcher
      #vkd3d-proton
    ]
  );
  #xorg-xwininfo
  #services.ludusavi.enable
  #services.gvfs.enable
  #services.opensnitch-ui.enable
  #programs.gamescope.enable
  #programs.gamemode.enable
  #programs.mangohud.enable
  #plasma-gamemode
  #xone-dongle-firmware
}
