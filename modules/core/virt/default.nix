{ ... }:
{
  imports = [
    (import ./config.nix)
    (import ./software.nix)
  ]
}
