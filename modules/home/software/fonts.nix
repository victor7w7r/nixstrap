{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    roboto
    openmoji-color
    open-sans
    nerd-fonts.noto
    nerd-fonts.jetbrains-mono
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.dejavu-sans-mono
    nerd-fonts.liberation
    nerd-fonts.ubuntu
    nerd-fonts.symbols-only
    font-awesome
  ];
}
