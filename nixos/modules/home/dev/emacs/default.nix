{
  inputs,
  config,
  pkgs,
  ...
}:
{
  nixpkgs.overlays = [
    inputs.emacs-overlay
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
