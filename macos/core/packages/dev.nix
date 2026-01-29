{ pkgs, ... }:
{
  environment.defaultPackages = with pkgs; [
    atac
    cocoapods
    colima
    ctop
    dive
    gh
    httpie
    git-extras
    glow
    just
    lima
    nemu
    oxker
    podman
    podman-tui
    rainfrog
    qemu
    zsh-forgit
  ];
}
