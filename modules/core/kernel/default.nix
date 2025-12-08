{ ... }:
{
  imports = [
    (import ./config.nix)
    (import ./initrd.nix)
    (import ./params.nix)
  ];
}
