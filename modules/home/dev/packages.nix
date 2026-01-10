{ pkgs, ... }:
{
  home.packages = (
    with pkgs;
    [
      bruno
      neovim
      cool-retro-term
      git-credential-manager
      lazygit
      jetbrains.datagrip
      windterm
    ]
  );
}
