{
  den.aspects.handheld.services =
    { user, ... }:
    {
      nixos =
        { lib, ... }:
        {
          services = {
            acpid.enable = true;
            asusd.enable = true;
            #auto-cpufreq.enable = true;
            lact.enable = true;
            tuned.enable = false;
            inputplumber.enable = lib.mkForce false;
            powerstation.enable = false;

            btrfs.autoScrub.fileSystems = [ "/run/media/games" ];

            handheld-daemon = {
              enable = false;
              user = user.name;
              ui.enable = false;
              adjustor.enable = true;
              adjustor.loadAcpiCallModule = true;
            };
          };
        };
    };
}
