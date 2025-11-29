{ pkgs, ... }:
{
  programs = {
    nix-ld.enable = true;
    nix-ld.libraries = with pkgs; [];
    zsh.enable = true;
    bat.enable = true;
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
    microcode-intel
    tmux
    git
    zoxide
    lsof
    blueman
    lvm2
    sshs
    ncdu
    sig
    sbctl
    inetutils
    linux-firmware
    ananicy-rules-cachyos
    edk2-uefi-shell
    memtest86plus
    arch-install-scripts
    efibootmgr
    busybox
    refind
    sshfs
    fdupes
    tpm2-tools
    mokutil
    terminus_font
    lshw
    gpart
    exfatprogs
    f2fs-tools
    ntfs3g
    mtools
    fuse-overlayfs
    usbutils
    cyme
    smartmontools
    ethtool
    iptables
    hblock
    slirp4netns
    lsb-release
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
    mesa
    driversi686Linux.mesa
    alsa-plugins
    alsa-utils
    alsa-firmware
    sof-firmware
    bluez
    bluez-alsa
    bluez-tools
    bluetui
    bluetuith
  ];
}
