{ inputs, ... }:
{
  imports = [ (import ./hypr.nix) ] ++ [ inputs.hyprland.homeManagerModules.default ];
}
