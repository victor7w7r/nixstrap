{ inputs, pkgs, ... }:
{
  environment.systemPackages =
    with pkgs;
    [
      gh
      gh-dash
      git
      git-lfs
      git-extras
      delta
      devbox
      emacs-nox
      nixd
    ]
    ++ [
      fw
      hub
      just
      zsh-forgit
    ]
    ++ [
      github-copilot-cli
      #jan
      #ollama-rocm
    ]
    ++ [
      atac
      httpie
      curlie
      dos2unix
      lemmeknow
      glow
      jless
      posting
      xh
    ]
    ++ [
      dblab
      gobang
      rainfrog
      ktlint
      shellcheck
      tracexec
    ]
    ++ [
      inputs.nix-search-tv.packages.x86_64-linux.default
      #(pkgs.callPackage ./custom/elia-chat.nix { })
      #(pkgs.callPackage ./custom/gpterminator.nix { })
      (pkgs.callPackage ./custom/jwt-ui.nix { })
      (pkgs.callPackage ./custom/kyun.nix { })
      (pkgs.callPackage ./custom/loc.nix { })
      (pkgs.callPackage ./custom/mynav.nix { })
      (pkgs.callPackage ./custom/ugm.nix { })
      (pkgs.callPackage ./custom/updo.nix { })
    ];
}
