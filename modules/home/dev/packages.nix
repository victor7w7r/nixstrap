{ pkgs, lib, ... }:
{
  home.packages = (
    with pkgs;
    [
      bruno
      cool-retro-term
      git-credential-manager
      lazygit
      jetbrains.datagrip
      #notepadqq
      windterm
    ]
  );
}
