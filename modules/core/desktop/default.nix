{ host, ... }:
{
  imports = [
    (import ./dm.nix)
  ]
  ++ (
    if (host == "v7w7r-youyeetoox1") then
      [
        (import ./xfce/config.nix)
        (import ./xfce/packages.nix)
      ]
    else
      [
        (import ./kde/config.nix)
        (import ./kde/packages.nix)
      ]
  );
}
