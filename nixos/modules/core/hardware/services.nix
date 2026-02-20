{ host, ... }:
let
  governor = (
    if host == "v7w7r-macmini81" then
      "ondemand"
    else if host == "v7w7r-youyeetoox1" then
      "performance"
    else
      "schedutil"
  );
in
{
  services = {
    blueman.enable = host != "v7w7r-nixvm";
    fwupd.enable = true;
    #lact.enable = true;
    sysstat.enable = true;
    smartd.enable = false;
    upower.enable = host != "v7w7r-youyeetoox1" && host != "v7w7r-macmini81";
    power-profiles-daemon.enable = false;
    thermald.enable = host != "v7w7r-youyeetoox1";
    udisks2.enable = true;
    tlp = {
      enable = true;
      settings =
        let
          is-term-hosts = host == "v7w7r-rc71l" || host == "v7w7r-youyeetoox1";
          is-battery = host == "v7w7r-higole" || host == "v7w7r-rc71l";
          is-gole = host == "v7w7r-higole";
          is-mac = host == "v7w7r-macmini81";
        in
        {
          CPU_SCALING_GOVERNOR_ON_AC = governor;
          CPU_SCALING_GOVERNOR_ON_BAT = if host == "v7w7r-rc71l" then "schedutil" else "powersave";
          CPU_ENERGY_PERF_POLICY_ON_AC = if is-gole then "default" else "balance_performance";
          CPU_ENERGY_PERF_POLICY_ON_BAT = if is-gole then "power" else "balance_power";
          CPU_BOOST_ON_AC = if is-term-hosts then 1 else 0;
          CPU_BOOST_ON_BAT = 0;
          CPU_HWP_DYN_BOOST_ON_AC = 1;
          CPU_HWP_DYN_BOOST_ON_BAT = 1;
          MEM_SLEEP_ON_AC = "s2idle";
          MEM_SLEEP_ON_BAT = "deep";
          PLATFORM_PROFILE_ON_BAT = "low-power";
          WOL_DISABLE = if host != "v7w7r-youyeetoox1" then "Y" else "N";

          # min_power, med_power_with_dipm(*), medium_power, max_performance.
          SATA_LINKPWR_ON_AC = "medium_power";
          SATA_LINKPWR_ON_BAT = "medium_power";
          WIFI_PWR_ON_AC = if is-gole then "on" else "off";
          WIFI_PWR_ON_BAT = if is-battery then "on" else "off";
          SOUND_POWER_SAVE_ON_AC = if is-gole then 1 else 0;
          SOUND_POWER_SAVE_ON_BAT = if is-gole then 1 else 0;
          USB_AUTOSUSPEND = if is-battery then 1 else 0;
          SCHED_POWERSAVE_ON_AC = 0;
          SCHED_POWERSAVE_ON_BAT = 1;
        }
        // (
          if is-mac then
            {
              CPU_MAX_PERF_ON_AC = 70;
            }
          else
            { }
        )
        // (
          if is-gole then
            {
              CPU_MAX_PERF_ON_BAT = 50;
              RUNTIME_PM_ON_BAT = "auto";
            }
          else
            { }
        );
    };

    pipewire = {
      enable = (host != "v7w7r-nixvm");
      extraConfig.pipewire = {
        "10-clock-quantum"."context.properties"."default.clock.min-quantum" = 1024;
        "99-allowed-rates"."context.properties"."default.clock.allowed-rates" = [
          44100
          48000
          88200
          96000
          176400
          192000
        ];
      };
      alsa = {
        enable = true;
        support32Bit = true;
      };
      jack.enable = true;
      pulse.enable = true;
      socketActivation = true;
      wireplumber.enable = true;
    };
  };
}
