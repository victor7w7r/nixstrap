{ pkgs, ... }:

{

  fontconfig = {
    enable = true;
    hinting.autohint = true;
  };

  home.packages = with pkgs; [
    roboto
    openmoji-color
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
