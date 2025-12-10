{ pkgs, ... }:
{
  home.packages = (
    with pkgs;
    [
      bruno
      cool-retro-term
      git-credential-manager
      jetbrains.datagrip
      lazygit
      #notepadqq
      windterm
    ]
  );

  programs = {
    zed-editor.enable = true;
    difftastic.enable = true;
    gitui.enable = true;
    lazysql.enable = true;
    #meli.enable = true; BUILD
    mods.enable = true;
    visidata.enable = true;
  };
}
