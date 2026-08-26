{
  den.aspects.phone.services.nixos = { config, lib, ... }: {
    systemd.services.usb-moded-turn-off-rescue-mode.enable = false;

    services = {
      fail2ban.enable = lib.mkForce false;
      bootmac = {
        enable = true;
        bluetooth.enable = true;
      };
      buffyboard = {
        enable = true;
        settings.input.touchscreen = true;
      };
      logind.settings = {
        Login.HandlePowerKey = lib.mkDefault "ignore";
        Login.HandlePowerKeyLongPress = lib.mkDefault "poweroff";
      };

      getty.autologinUser = "victor7w7r";
      hexagonrpcd.sdsp.enable = false;
      msm-modem-uim-selection.enable = true;
      rmtfs.enable = false;
      swclock-offset.enable = true;
      upower.enable = true;
      tqftpserv.enable = false;

      udev.extraRules = ''
        ACTION=="remove", GOTO="iio_sensor_proxy_end"
        SUBSYSTEM=="misc", KERNEL=="fastrpc-adsp*", ENV{IIO_SENSOR_PROXY_TYPE}+="ssc-accel ssc-proximity"
        SUBSYSTEM=="misc", KERNEL=="fastrpc-sdsp*", ENV{IIO_SENSOR_PROXY_TYPE}+="ssc-accel ssc-proximity"
        LABEL="iio_sensor_proxy_end"
      '';

      openssh = {
        openFirewall = lib.mkForce false;
        listenAddresses = [
          {
            addr = "0.0.0.0";
            port = 22;
          }
        ];
        settings = {
          UsePAM = lib.mkImageMediaOverride true;
        };
      };
    };
  };
}
