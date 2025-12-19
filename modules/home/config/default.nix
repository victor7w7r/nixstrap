{ ... }:
{
  imports = [
    (import ./kitty.nix)
    (import ./zed.nix)
    (import ./zen.nix)
  ];
}
