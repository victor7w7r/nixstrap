{ ... }:
{
  imports = [
    (import ./eq.nix)
    (import ./config.nix)
    (import ./packages.nix)
  ];
}
