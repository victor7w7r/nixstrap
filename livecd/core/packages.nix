{ pkgs, ... }:
{
  environment.defaultPackages = with pkgs; [
    asciiquarium-transparent
    busybox
    cmatrix
    genact
    exfatprogs
    f2fs-tools
    lavat
    lm_sensors
    nbsdgames
    ncdu
    nix-du
    p7zip
    pipes-rs
    progress
    rsyncy
    sl
    ternimal
    tmux
  ];

}
