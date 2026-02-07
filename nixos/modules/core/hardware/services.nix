{ host, pkgs, ... }:
{
  services = {
    blueman.enable = (host != "v7w7r-nixvm");
    fwupd.enable = true;
    lact.enable = true;
    sysstat.enable = true;
    smartd.enable = false;
    thermald.enable = true;
    udisks2.enable = true;

    /*pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
      };*/

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
      tlp = {
        enable = true;
        settings = {
          #DISK_IDLE_SECS_ON_AC=
          #DISK_IDLE_SECS_ON_BAT=
          CPU_SCALING_GOVERNOR_ON_AC="ondemand";
          CPU_SCALING_GOVERNOR_ON_BAT="ondemand"; #schedutil powersave
          #CPU_SCALING_MIN_FREQ_ON_AC=0;
          #CPU_SCALING_MAX_FREQ_ON_AC=0;
          #CPU_SCALING_MIN_FREQ_ON_BAT=0;
          #CPU_SCALING_MAX_FREQ_ON_BAT=0;

          # performance, balance_performance, default, balance_power, power.
          #CPU_ENERGY_PERF_POLICY_ON_AC="balance_performance";
          CPU_ENERGY_PERF_POLICY_ON_BAT="balance_power";
          CPU_BOOST_ON_AC=1;
          CPU_BOOST_ON_BAT=1;
          CPU_HWP_DYN_BOOST_ON_AC=1;
          CPU_HWP_DYN_BOOST_ON_BAT=1;
          MEM_SLEEP_ON_AC="s2idle";
          MEM_SLEEP_ON_BAT="deep";

          #   min_power, med_power_with_dipm(*), medium_power, max_performance.
          SATA_LINKPWR_ON_AC="medium_power";
          SATA_LINKPWR_ON_BAT="medium_power";

          # Wi-Fi power saving mode: on=enable, off=disable.
          # Default: off (AC), on (BAT)

          #WIFI_PWR_ON_AC=
          WIFI_PWR_ON_BAT="on";
          #SOUND_POWER_SAVE_ON_AC=
          SOUND_POWER_SAVE_ON_BAT=1;
          USB_AUTOSUSPEND=1;

          # BAT0: Main battery
          # Default: <none>

          # Battery charge level below which charging will begin.
          #START_CHARGE_THRESH_BAT0=75;
          # Battery charge level above which charging will stop.
          #STOP_CHARGE_THRESH_BAT0=80;

          # BAT1: Secondary battery (primary on some laptops)
          # Default: <none>

          # Battery charge level below which charging will begin.
          #START_CHARGE_THRESH_BAT1=75;
          # Battery charge level above which charging will stop.
          #STOP_CHARGE_THRESH_BAT1=80;
        };
      };
    };
  };
}
