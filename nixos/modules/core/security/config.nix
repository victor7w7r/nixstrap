{ username, ... }:
{
  security = {
    apparmor = {
      enable = true;
      enableCache = true;
    };
    polkit.enable = true;
    pam.services."${username}".kwallet = {
      enable = true;
      package = pkgs.kdePackages.kwallet-pam;
    };
    rtkit.enable = true;
    #clamav-gui clamav-unofficial-sigs
    sudo-rs = {
      enable = true;
      wheelNeedsPassword = false;
    };
  };
}
