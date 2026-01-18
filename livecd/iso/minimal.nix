{ lib, modulesPath, ... }:
{
  imports = [
    "${modulesPath}/profiles/minimal.nix"
    ./base.nix
  ];

  isoImage.edition = lib.mkOverride 500 "minimal";
  fonts.fontconfig.enable = lib.mkOverride 500 false;
}
