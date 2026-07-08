{ inputs, ... }:
{
  flake-file.inputs = {
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-doom-emacs-unstraightened = {
      url = "github:marienz/nix-doom-emacs-unstraightened";
      inputs.nixpkgs.follows = "";
    };
  };

  den.aspects.emacs =
    { user, ... }:
    {
      os =
        { inputs', pkgs, ... }:
        {
          nixpkgs.overlays = [
            inputs'.emacs-overlay.overlay
            inputs'.emacs-config.overlays.default
          ];
          environment.systemPackages = with pkgs; [ emacs-nox ];
        };

      nixos =
        { isPersistent, lib, ... }:
        {
          environment.persistence."/nix/persist".users."${user.name}".directories =
            lib.optionals isPersistent
              [
                ".local/share/emacs"
                ".cache/doom"
              ];
        };

      provides.to-users.homeManager =
        { config, pkgs, ... }:
        {
          imports = [ inputs.nix-doom-emacs-unstraightened.homeModule ];
          programs.doom-emacs = {
            enable = false;
            emacs = pkgs.emacs-nox;
            doomDir = ./.;
            doomLocalDir = "${config.home.homeDirectory}/.local/share/emacs";
            extraPackages = epkgs: with epkgs; [ melpaPackages.nixos-options ];
            extraBinPackages = with pkgs; [
              git
              ripgrep
              fd
            ];
          };
        };
    };
}
