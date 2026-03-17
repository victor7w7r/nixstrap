{ ... }:
{
  imports = [
    (import ./config.nix)
    (import ./emacs)
    (import ./packages.nix)
    (import ./vim)
    (import ./zed.nix)
  ];
}
