{ ... }:
{
  imports = [
    (import ./config.nix)
    (import ./emacs)
    (import ./packages.nix)
    (import ./zed.nix)
  ];
}
