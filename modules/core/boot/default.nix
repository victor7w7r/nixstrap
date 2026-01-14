{ ... }:
{
  imports = [
    (import ./bootloader.nix)
    (import ./emulation.nix)
    (import ./kernel.nix)
  ];
}
