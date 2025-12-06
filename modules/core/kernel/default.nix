{ ... }:
{
  imports = [
    (import ./config.nix)
    (import ./initrd.nix)
    (import ./hooks.nix)
    (import ./params.nix)
    (import ./sysctl.nix)
  ]
}
