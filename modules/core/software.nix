{ pkgs, ... }:
{
  programs = {
    nix-ld.enable = true;
    nix-ld.libraries = [ ];
    zsh.enable = true;
    less.enable = true;
    skim.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    appimage = {
      enable = true;
      binfmt = true;
    };
    #bash.blesh.enable = true;
  };

  environment.defaultPackages = [ ];
  environment.systemPackages = with pkgs; [
    tmux
    git
    zoxide
    lsof
    blueman
    sshs
    ncdu
    sig
    sbctl
    inetutils
    ananicy-rules-cachyos
    sshfs
    fdupes
    tpm2-tools
    mokutil
    lshw
    gpart
    exfatprogs
    f2fs-tools
    mtools
    fuse-overlayfs
    usbutils
    cyme
    smartmontools
    ethtool
    iptables
    hblock
    slirp4netns
    zip
    unzip
    p7zip
    rar
    desed
    clolcat
    fortune
    xclip
    cod
    xsel
    sscg
    rrdtool
    luksmeta
    emacs-nox
    tre-command
    mommy
    jfbview
    brush
    dotter
    emptty
    rnr
    alsa-plugins
    alsa-utils
    alsa-firmware
    bluetui
    bluetuith
  ];
}
