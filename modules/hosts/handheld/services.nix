{
  den.aspects.handheld.services =
    { user, ... }:
    {
      nixos =
        { lib, pkgs, ... }:
        {
          services = {
            acpid.enable = true;
            asusd.enable = true;
            #auto-cpufreq.enable = true;
            lact.enable = true;
            tuned.enable = false;
            inputplumber.enable = lib.mkForce false;
            powerstation.enable = false;
            upower.enable = true;
            btrfs.autoScrub.fileSystems = [ "/run/media/games" ];
            fwupd.enable = true;
            udev.packages = with pkgs; [
              hhd
            ];

            handheld-daemon = {
              enable = true;
              user = user.name;
              ui.enable = true;
              adjustor.enable = true;
              adjustor.loadAcpiCallModule = true;
            };
          };
        };
    };
}
