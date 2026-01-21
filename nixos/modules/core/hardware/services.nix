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

    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
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
