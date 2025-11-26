{ pkgs, ... }:
{
  fonts = {
    fonts = with pkgs; [
      jetbrains-mono
      roboto
      openmoji-color
      nerd-fonts-noto
      noto-fonts-cjk
      noto-fonts-color-emoji
      nerd-fonts-jetbrains-mono
      dejavu-fonts
      nerd-fonts-liberation
      nerd-fonts-dejavu-sans-mono
      nerd-fonts-ubuntu
      nerd-fonts-symbols-only
      font-awesome
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];

    fontconfig = {
      hinting.autohint = true;
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
