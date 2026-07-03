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
              enable = true;
              user = user.name;
              ui.enable = true;
              adjustor.enable = true;
              adjustor.loadAcpiCallModule = true;
            };

            supergfxd = {
              enable = true;
              settings = {
                vfio_enable = true;
                vfio_save = false;
                always_reboot = false;
                no_logind = false;
                logout_timeout_s = 20;
                hotplug_type = "Asus";
              };
            };
          };
        };
    };
}
