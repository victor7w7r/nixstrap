{ ... }:
{
  imports = [
    (import ./fetch.nix)
    (import ./games.nix)
    (import ./steam.nix)
  ];
}
