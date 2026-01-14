{ ... }:
{
  security = {
    apparmor = {
      enable = true;
      enableCache = true;
    };
    polkit.enable = true;
    rtkit.enable = true;
    #clamav-gui clamav-unofficial-sigs
    sudo-rs = {
      enable = true;
      wheelNeedsPassword = false;
      extraConfig = ''
        Defaults lecture = never
      '';
    };
  };
}
