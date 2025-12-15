{ pkgs, ... }:
{
  #programs.gamemode.enable = true;
  #programs.mangohud.enable = true;

  services.ludusavi.enable = true;

  home.packages = with pkgs; [
    bottles
    dosbox
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
