{ ... }:
{
  imports = [
    (import ./config.nix)
    (import ./pam.nix)
    (import ./services.nix)
  ];
}
