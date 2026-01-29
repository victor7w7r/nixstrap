{ ... }:
{
  imports = [
    (import ./bootloader.nix)
    (import ./emulation.nix)
    (import ./kernel.nix)
    (import ./persist.nix)
    (import ./sysctl.nix)
  ];
}
