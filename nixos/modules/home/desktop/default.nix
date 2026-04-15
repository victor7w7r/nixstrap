{ host, ... }:
{
  imports =
    (
      if (host != "v7w7r-youyeetoox1" && host != "v7w7r-opizero2w" && host != "v7w7r-fajita") then
        [
          ./plasma
          ./xdg.nix
          ./entries.nix
          # ./hypr
          #inputs.hyprland.homeManagerModules.default
        ]
      else
        [ ]
    )
    ++ (if (host != "v7w7r-opizero2w") then [ ./theme ] else [ ]);
}
