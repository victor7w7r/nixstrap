{ ... }:
{
  imports = [
    (import ./fonts.nix)
    (import ./gtk.nix)
    (import ./packages.nix)
  ];

}
