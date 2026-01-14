{ host, ... }:
{
  imports = [
    (import ./display-manager.nix)
    (import ./flatpak.nix)
    (import ./xdg.nix)
  ]
  ++ (if (host == "v7w7r-youyeetoox1") then [ (import ./xfce.nix) ] else [ (import ./plasma.nix) ]);
}
