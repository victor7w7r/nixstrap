{ pkgs, ... }:
{
  environment.defaultPackages = with pkgs; [
    asciiquarium-transparent
    busybox
    cmatrix
    genact
    dos2unix
    exfatprogs
    file
    f2fs-tools
    gnused
    inetutils
    lavat
    lm_sensors
    lshw
    lsof
    nbsdgames
    ncdu
    nix-du
    p7zip
    pipes-rs
    progress
    rsyncy
    sl
    superfile
    ternimal
    tmux
    tty-solitaire
    wget
    wget2
  ];

  system.extraDependencies = with pkgs; [
    stdenv
    stdenvNoCC
    jq
    makeInitrdNGTool
  ];
}
