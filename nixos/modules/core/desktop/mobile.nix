{ pkgs, ... }:
{
  services = {
    libinput.enable = true;
    xserver = {
      enable = true;
      desktopManager.plasma5.mobile.enable = true;
      displayManager = {
        autoLogin = {
          enable = true;
          user = "victor7w7wr";
        };
        defaultSession = "plasma-mobile";
        sessionPackages = [ pkgs.kdePackages.plasma-mobile ];
        lightdm = {
          enable = true;
          extraSeatDefaults = ''
            session-cleanup-script=${pkgs.procps}/bin/pkill -P1 -fx ${pkgs.lightdm}/sbin/lightdm
          '';
        };
      };
    };
  };
}
