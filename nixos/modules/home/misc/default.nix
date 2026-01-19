{ ... }:
{
  imports = [
    (import ./config.nix)
    (import ./gaming.nix)
    (import ./packages.nix)
    (import ./services.nix)
  ];
}
