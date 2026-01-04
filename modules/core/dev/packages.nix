{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
    git-extras
    emacs-nox

    fw
    hub
    just
    zsh-forgit

    github-copilot-cli
    jan
    ollama-rocm

    atac
    xh
    httpie
    curlie
    posting
    glow
    jless
    dos2unix
    lemmeknow

    dblab
    gobang
    rainfrog
    ktlint
    shellcheck
    tracexec

    (pkgs.callPackage ./custom/elia-chat.nix { })
    (pkgs.callPackage ./custom/gpterminator.nix { })
    (pkgs.callPackage ./custom/jwt-ui.nix { })
    (pkgs.callPackage ./custom/kyun.nix { })
    (pkgs.callPackage ./custom/loc.nix { })
    (pkgs.callPackage ./custom/mynav.nix { })
    (pkgs.callPackage ./custom/ugm.nix { })
    (pkgs.callPackage ./custom/updo.nix { })
  ];
}
