{ host, ... }:
{
  imports = [
    (import ./flatpak.nix)
    (import ./xdg.nix)
  ]
  ++ (if (host == "v7w7r-youyeetoox1") then [ (import ./xfce.nix) ] else [ ])
  ++ (
    if (host == "v7w7r-rc71l" || host == "v7w7r-higole" || host == "v7w7r-macmini81") then
      [ (import ./plasma.nix) ]
    else
      [ ]
  )
  ++ (
    if (host == "v7w7r-fajita") then [ (import ./mobile.nix) ] else [ (import ./display-manager.nix) ]
  );
}
