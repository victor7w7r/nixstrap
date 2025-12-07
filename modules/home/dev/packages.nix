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
      notepadqq
      windterm
    ]
  );

  programs = {
    zed-editor.enable = true;
  };
}
