{ ... }:
{
  imports = [
    (import ./config.nix)
    (import ./services.nix)
    (import ./software.nix)
    (import ./samba.nix)
  ]
}
