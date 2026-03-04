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
        (epkgs.melpaBuild {
          pname = "lsp-augment";
          version = "v0.33.0";
          packageRequires = [ epkgs.dash ];
          src = builtins.fetchTree {
            type = "github";
            rev = "main";
            owner = "rolandd";
            repo = "augment.vim";
          };
        })
      ];
    extraBinPackages = with pkgs; [
      git
      ripgrep
      fd
    ];
  };
}
