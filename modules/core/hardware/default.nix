{ ... }:
{
  imports = [
    (import ./config.nix)
    (import ./packages.nix)
    (import ./services.nix)
    (import ./udev.nix)
  ];
}
