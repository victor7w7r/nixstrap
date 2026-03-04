{ config, pkgs, ... }:
{
  nixpkgs.overlays = [
    (import (
      builtins.fetchTarball {
        url = "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
      }
    ))
  ];

  programs.doom-emacs = {
    enable = true;
    emacs = pkgs.emacs-nox;
    doomDir = ./.;
    doomLocalDir = "${config.home.homeDirectory}/.local/share/nix-doom";
    extraPackages =
      epkgs: with epkgs; [
        melpaPackages.nixos-options
      ];
    extraBinPackages = with pkgs; [
      git
      ripgrep
      fd
    ];
  };
}
