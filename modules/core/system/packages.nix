{ pkgs, ... }:
{
  environment.systemPackages =
    with pkgs;
    [
      age
      atool
      brush
      cheat
      cmd-wrapped
      cod
      emptty
      gnused
      jump
      lsof
      luksmeta
      mokutil
      rsyncy
      p7zip
      progress
      pv
      sampler
      ssh-to-age
      sd
      sig
      sops
      tre-command
      tmux
      veracrypt
      vtm
      wtfutil
      zoxide

      (pkgs.callPackage ./custom/hf.nix { })
      (pkgs.callPackage ./custom/loop.nix { })
      (pkgs.callPackage ./custom/progressline.nix { })
      (pkgs.callPackage ./custom/texoxide.nix { })
      #(pkgs.callPackage ./custom/procmux.nix { })
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
      #pcp
      #https://github.com/codervijo/journalview
      #https://github.com/jasonwitty/socktop
      #https://github.com/XhuyZ/lazysys
      #uv pip install tiptop
      #nvtopPackages.intel
    ];
}
