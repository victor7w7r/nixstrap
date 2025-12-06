{ pkgs, lib, ... }:
{

  programs = {
    nix-ld.enable = true;
    nix-ld.libraries = [ ];
    rclone.enable = true;
    zsh.enable = true;
    less.enable = true;
    skim.enable = true;
    #bash.blesh.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    appimage = {
      enable = true;
      binfmt = true;
    };
  };

  environment.systemPackages =
    with pkgs;
    lib.mkAfter [
      #texoxide
      #pcp
      #https://github.com/trmckay/fzf-open
      gnused
      brush
      desed
      sd
      sig
      tre-command
      tmux
      git
      lsof
      cod
      ncdu
      zoxide
      jump
      rsyncy
      mmv-go
      lnav
      emacs-nox
      fclones
      fdupes
      duff
      rdfind
      rnr
      cyme
      lshw
      smartmontools
      usbutils
      cpulimit
      gpart
      sshfs
      exfatprogs
      f2fs-tools
      mtools
      luksmeta
      mokutil
      imgcat
      lsix
      jfbview
      timg
      emptty
      veracrypt
      vtm
      sscg
      p7zip
    ];
}
