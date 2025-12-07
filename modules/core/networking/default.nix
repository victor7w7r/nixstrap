{ ... }:
{
  imports = [
    (import ./config.nix)
    (import ./services.nix)
    (import ./samba.nix)
  ];
}
