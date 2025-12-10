{ pkgs, lib, ... }:
{
  environment.systemPackages =
    with pkgs;
    lib.mkAfter [
      atool
      brush
      cheat
      cmd-wrapped
      cod
      emacs-nox
      emptty
      git
      git-extras
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
      sd
      sig
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
    ];

  programs = {
    appimage = {
      enable = true;
      binfmt = true;
    };
    #bash.blesh.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    less.enable = true;
    skim.enable = true;
    zsh.enable = true;
  };
}
