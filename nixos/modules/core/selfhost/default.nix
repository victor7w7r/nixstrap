{ ... }:
{
  imports = [
    (import ./harmonia.nix)
    (import ./proxmox.nix)
    (import ./sleep.nix)
  ];
}
