{ pkgs, ... }:
{
  #programs.gamemode.enable = true;
  #programs.mangohud.enable = true;
  /*
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
      protontricks.enable = true;
    }; #TO CORE
  */

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
