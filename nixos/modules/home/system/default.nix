{ host, username, ... }:
{
  imports = [
    (import ./bat.nix)
    (import ./btop.nix)
    (import ./config.nix)
    (import ./starship.nix)
    (import ./tmux)
    (import ./bash)
    (import ./zsh)
  ]
  ++ (
    if username != "root" && host != "v7w7r-opizero2w" then
      [
        (import ./kitty.nix)
        (import ./services.nix)
        (import ./packages.nix)
      ]
    else
      [ ]
  );
}
