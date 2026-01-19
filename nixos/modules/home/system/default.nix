{ ... }:
{
  imports = [
    (import ./bat.nix)
    (import ./btop.nix)
    (import ./config.nix)
    (import ./kitty.nix)
    (import ./packages.nix)
    (import ./services.nix)
    (import ./starship.nix)
  ];
}
