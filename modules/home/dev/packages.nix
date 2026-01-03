{ pkgs, lib, ... }:
{
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "jetbrains.datagrip"
    ];

  home.packages = (
    with pkgs;
    [
      bruno
      cool-retro-term
      git-credential-manager
      lazygit
      #notepadqq
      windterm
    ]
  );
}
