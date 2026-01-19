{ ... }:
{
  imports = [
    (import ./config.nix)
    (import ./packages.nix)
    (import ./zed.nix)
  ];
}
