{ ... }:
{
  imports = [
    (import ./config.nix)
    (import ./services.nix)
  ];
}
