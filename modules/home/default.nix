{ host, ... }:
{
  imports = [
    (import ./bat)
    (import ./btop)
    (import ./fonts)
    (import ./packages)
    (import ./plasma)
  ]
  ++ (if (host != "vm") || (host != "server") then [ (import ./gaming.nix) ] else [ ]);
  #if (host == "desktop") then [ ./../home/default.desktop.nix ]
}
