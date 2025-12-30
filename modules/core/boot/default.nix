{ ... }:
{
  imports = [
    (import ./bootloader.nix)
    (import ./kernel.nix)
  ];
}
