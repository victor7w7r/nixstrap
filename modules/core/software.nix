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

  ];
}
