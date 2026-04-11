{ pkgs, ... }:
{
  services = {
    libinput.enable = true;
    displayManager = {
      autoLogin.enable = true;
      defaultSession = "plasma-mobile";
    };
    xserver = {
      enable = true;
      desktopManager.plasma5.mobile.enable = true;
      displayManager.lightdm = {
        enable = true;
        extraSeatDefaults = ''
          session-cleanup-script=${pkgs.procps}/bin/pkill -P1 -fx ${pkgs.lightdm}/sbin/lightdm
        '';
      };
    };
  };
}
