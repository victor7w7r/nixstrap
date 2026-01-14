{ pkgs, ... }:
{
  fonts = {
    fontDir.enable = true;
    enableDefaultPackages = true;
    fontconfig = {
      enable = true;
      useEmbeddedBitmaps = true;
      subpixel.rgba = "rgb";
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" ];
      };
    };
  };

  home.packages = with pkgs; [
    corefonts
    dejavu_fonts
    font-awesome
    liberation_ttf
    libertine
    libertinus
    hack-font
    noto-fonts-cjk-sans
    nerd-fonts.code-new-roman
    noto-fonts-color-emoji
    nerd-fonts.dejavu-sans-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.liberation
    nerd-fonts.noto
    nerd-fonts.roboto-mono
    nerd-fonts.symbols-only
    nerd-fonts.ubuntu
    openmoji-color
    open-sans
  ];
}
