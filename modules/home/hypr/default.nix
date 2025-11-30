{ inputs, ... }:
{
  imports = [ (import ./hyprland.nix) ] ++ [ inputs.hyprland.homeManagerModules.default ];
}
