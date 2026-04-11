{ host, ... }:
{
  imports = [
    ./config.nix
    ./emacs
    ./packages.nix
  ]
  ++ (if host != "v7w7r-opizero2w" then [ ./zed.nix ] else [ ]);
}
