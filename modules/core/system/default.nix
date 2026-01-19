{ ... }:
{
  imports = [
    (import ./config.nix)
    (import ./services.nix)
    (import ./packages.nix)
    (import ./systemd.nix)
    #(import ./time.nix)
  ];
}
