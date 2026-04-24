{ ... }:
{
  programs.nixvim = {
    enable = false;
    colorschemes.catppuccin.enable = true;
    plugins.lualine.enable = true;
  };
}
