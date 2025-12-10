{ ... }:
{
  imports = [
    (import ./bat.nix)
    (import ./btop.nix)
    (import ./packages.nix)
  ];
}
