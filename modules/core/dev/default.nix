{ ... }:
{
  imports = [
    (import ./config.nix)
    (import ./packages.nix)
    (import ./custom/ugm.nix)
  ];
}
