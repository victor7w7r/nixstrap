{ ... }:
{
  imports = [
    (import ./btop.nix)
    (import ./fonts.nix)
    (import ./packages.nix)
    (import ./plasma.nix)
  ];
}
