{ ... }:
{
  imports = [
    (import ./config.nix)
    (import ./vim)
    (import ./packages.nix)
  ];
}
