{ lib, modulesPath, ... }:

{
  imports = [
    "${modulesPath}/profiles/minimal.nix"
    ./base.nix
  ];

  isoImage.edition = lib.mkOverride 500 "minimal";

  documentation.man.enable = lib.mkOverride 500 true;
  documentation.doc.enable = lib.mkOverride 500 true;
  fonts.fontconfig.enable = lib.mkOverride 500 false;
}
