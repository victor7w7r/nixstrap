{ pkgs, ... }:
{
  services.easyeffects = {
    enable = true;
    package = pkgs.stable.easyeffects;
  };

}
