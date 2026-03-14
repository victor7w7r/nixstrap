{ username, ... }:
{
  imports = [
    (import ./bat.nix)
    (import ./btop.nix)
    (import ./config.nix)
    (import ./starship.nix)
    (import ./tmux)
    (import ./zsh)
  ] ++ (if username != "root" then [
    (import ./kitty.nix)
    (import ./services.nix)
    (import ./packages.nix)
  ] else [

  ]);
}
