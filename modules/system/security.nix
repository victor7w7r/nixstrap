{ pkgs, ... }:

{
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };
  security.secureboot.keystore = {
    enable = true;
    enrollKeys = true;
    includeMicrosoft = true;
  };
}
