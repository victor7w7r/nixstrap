{ ... }:
{
  imports = [
    (import ./config.nix)
    (import ./packages.nix)
  ];
}
