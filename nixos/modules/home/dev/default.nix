{ host, ... }:
{
  imports = [
    ./config.nix
    ./packages.nix
  ]
  ++ (
    if host != "v7w7r-opizero2w" && host != "v7w7r-fajita" then
      [
        ./zed.nix
        ./emacs
      ]
    else
      [ ]
  );
}
