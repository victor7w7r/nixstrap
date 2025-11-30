{ ... }:
{
  services = {
    #opensnitch.enable = true;
    logrotate.enable = true;
    clamav = {
      daemon.enable = true;
      updater.enable = true;
      scanner.enable = true;
    };
  };
  security = {
    apparmor = {
      enable = true;
      enableCache = true;
    };
    rtkit.enable = true;
    #clamav-gui clamav-unofficial-sigs
    sudo-rs = {
      enable = true;
      wheelNeedsPassword = false;
    };
  };
}
