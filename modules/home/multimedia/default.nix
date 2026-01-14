{ ... }:
{
  imports = [
    (import ./eq)
    (import ./config.nix)
    (import ./packages.nix)
  ];
}
