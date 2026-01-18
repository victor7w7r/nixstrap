{
  imports = [
    (import ./boot.nix)
    (import ./hardware.nix)
    (import ./networking.nix)
    (import ./packages.nix)
    (import ./services.nix)
    (import ./system.nix)
  ];
}
