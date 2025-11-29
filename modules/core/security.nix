{ ... }:
{
  security = {
    apparmor = {
      enable = true;
      enableCache = true;
    };
    rtkit.enable = true;
    sudo-rs = {
      enable = true;
      wheelNeedsPassword = false;
    };
  };
}