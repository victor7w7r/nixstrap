{ lib, ... }:
{
  imports = [ ./base.nix ];

  isoImage.edition = lib.mkOverride 500 "minimal";
  fonts.fontconfig.enable = lib.mkOverride 500 false;

  xdg = with lib; {
    autostart.enable = mkDefault false;
    icons.enable = mkDefault false;
    mime.enable = mkDefault false;
    sounds.enable = mkDefault false;
  };
}
