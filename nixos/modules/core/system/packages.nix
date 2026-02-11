{ inputs, pkgs, ... }:
{
  environment.systemPackages =
    with pkgs;
    [
      age
      atool
      brightnessctl
      brush
      boxxy
      cheat
      choose
      cmd-wrapped
      cod
      emptty
      gnused
      inotify-tools
      file
      firejail
      hexyl
      jump
      lsof
      luksmeta
      keyd
      killall
      mokutil
      rsyncy
      p7zip
      phraze
      progress
      pv
      rage
      sampler
      ssh-to-age
      sbctl
      sd
      sig
      sops
      tre-command
      tpm2-tools
      tmux
      veracrypt
      vtm
      wtfutil
      #(pkgs.callPackage ./custom/hf.nix { })
      #(pkgs.callPackage ./custom/loop.nix { })
      #(pkgs.callPackage ./custom/procmux.nix { })
      #(pkgs.callPackage ./custom/progressline.nix { })
      (pkgs.callPackage ./custom/texoxide.nix { })
    ]
    ++ [
      superfile
      termscp
      tran
      trash-cli
      tuifimanager
      walk
      #https://codeberg.org/sylphenix/sff
      (pkgs.callPackage ./custom/fman.nix { })
    ]
    ++ [
      dust
      dua
      gdu
      ncdu
      duff
      fclones
      mmv-go
      fdupes
      rdfind
      rnr
      (pkgs.callPackage ./custom/diskonaut.nix { })
    ]
    ++ [
      fatrace
      kmon
      lazyjournal
      lnav
      pik
      s-tui
      systemctl-tui
      sysz
      watchexec
      zps
      nvtopPackages.full
      #(pkgs.callPackage ./custom/journalview.nix { })
      #https://github.com/jasonwitty/socktop
      #https://github.com/XhuyZ/lazysys
      #pcp
      #uv pip install tiptop
    ]
    ++ [
      alejandra
      cached-nix-shell
      comma
      deadnix
      lorri
      fh
      manix
      namaka
      niv
      inputs.nix-alien.packages.${system}.nix-alien
      nix-diff
      nix-du
      nix-health
      nix-init # !!!!!
      nix-melt
      nix-output-monitor
      nixpkgs-review
      nix-search-cli
      nix-tree
      nix-update
      nixfmt
      nvd
      optnix
      statix
    ];
}
