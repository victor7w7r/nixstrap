{ host, ... }:
{
  imports = [
    (import ./theme)
  ]
  ++ (
    if (host != "v7w7r-nixvm") || (host != "v7w7r-youyeetoox1") then
      [
        (import ./plasma)
        #(import ./hypr)
        #inputs.hyprland.homeManagerModules.default
      ]
    else
      [ ]
  );
}
