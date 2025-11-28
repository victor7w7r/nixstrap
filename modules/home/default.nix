{inputs, username, host, ...}: {
  imports =
    [(import ./btop.nix)]
    ++ [(import ./fonts.nix)]
    ++ [(import ./packages.nix)];
}