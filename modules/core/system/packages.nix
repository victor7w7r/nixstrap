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
      #https://github.com/nvbn/thefuck
      #https://github.com/napisani/procmux
      #https://github.com/kattouf/ProgressLine
      #https://github.com/Miserlou/Loop
      #texoxide
    ]
    ++ [
      superfile
      termscp
      tran
      trash-cli
      tuifimanager
      walk
      #https://github.com/mananapr/cfiles
      #https://codeberg.org/sylphenix/sff
      #https://github.com/nore-dev/fman
      #https://github.com/sorairolake/hf

      dust
      dua
      gdu
      ncdu
      #diskonaut

      duff
      fclones
      mmv-go
      fdupes
      rdfind
      rnr
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
      #iotop-c
      #pcp
      #https://github.com/codervijo/journalview
      #https://github.com/jasonwitty/socktop
      #https://github.com/XhuyZ/lazysys
      #uv pip install tiptop
      #nvtopPackages.intel
    ];
}
