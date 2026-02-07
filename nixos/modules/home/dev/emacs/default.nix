{ pkgs, ... }: {
  programs.doom-emacs = {
    enable = true;
    emacs = pkgs.emacs-nox;
    doomDir = ./.;
    doomLocalDir = "~/.local/share/nix-doom";
    extraPackages = epkgs: with epkgs; [
      melpaPackages.nixos-options
    ];
    extraBinPackages = with pkgs; [
      git
      ripgrep
      fd
    ];
  };
}
