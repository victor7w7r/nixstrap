{ ... }:
{
  imports = [
    (import ./kernel.nix)
    (import ./config.nix)
    (import ./services.nix)
    (import ./systemd.nix)
    (import ./performance.nix)
    (import ./udev.nix)
    (import ./bootloader.nix)
  ];
}
