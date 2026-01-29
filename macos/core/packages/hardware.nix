{ pkgs, ... }:
{
  environment.defaultPackages = with pkgs; [
    cpufetch
    cyme
    glances
    macchina
    m-cli
    onefetch
    pfetch-rs
    smartmontools
    testdisk
  ];
}
