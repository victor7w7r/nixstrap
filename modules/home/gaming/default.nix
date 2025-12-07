{
  pkgs,
  stdenv,
  fetchFromGitLab,
  cmake,
  ...
}:

let
  plasma-gamemode = stdenv.mkDerivation {
    pname = "plasma-gamemode";
    version = "1.0.0";
    src = fetchFromGitLab {
      domain = "invent.kde.org";
      owner = "sitter";
      repo = "plasma-gamemode";
      rev = "4d6035834c993a9c2d23d8f46f3d3f0e84ae6604";
      hash = "sha256-XFdSPvq/Yz8Q3OTkclECTGwJJwXXZfjwjy+1PsRJiv4=";
    };

    dontWrapQtApps = true;
    nativeBuildInputs = with pkgs; [
      cmake
      kdePackages.extra-cmake-modules
    ];
    buildInputs = with pkgs.kdePackages; [
      kcoreaddons
      kdbusaddons
      ki18n
      kdeclarative
      libplasma
    ];
  };
in
{
  #programs.gamemode.enable = true;
  #programs.mangohud.enable = true;
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
    protontricks.enable = true;
  };

  services.ludusavi.enable = true;

  environment.systemPackages = with pkgs; [
    bottles
    dosbox
    umu-launcher
    goverlay
    inotify-info
    #nyrna
    plasma-gamemode
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
