{ host, ... }:
{
  imports = [
    (import ./theme)
  ]
  ++ (
    if (host != "v7w7r-youyeetoox1" && host != "v7w7r-opizero2w") then
      [
        (import ./plasma)
        (import ./xdg.nix)
        (import ./entries.nix)
        #(import ./hypr)
        #inputs.hyprland.homeManagerModules.default
      ]
    else
      [ ]
  );
}
