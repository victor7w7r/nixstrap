{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bottles
    umu-launcher
    goverlay
    inotify-info
    #nyrna
    #xorg-xwininfo
    #xone-dongle-firmware
    prismlauncher
    protonup-qt
    vkd3d-proton
    vkbasalt
    winetricks
  ];
}
/*
  wineWowPackages.staging
    wineWowPackages.waylandFull
    wineWowPackages.fonts
*/
