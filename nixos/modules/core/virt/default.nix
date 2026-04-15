{ host, ... }:
{
  imports = [
    (import ./config.nix)
  ]
  ++ (if (host != "v7w7r-opizero2w" && host != "v7w7r-fajita") then [ (import ./packages) ] else [ ]);
}
