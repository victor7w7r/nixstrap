{
  den.aspects.phone.services.nixos = { config, lib, ... }: {
    services = {
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
      hexagonrpcd.sdsp.enable = true;
      msm-modem-uim-selection.enable = true;
      rmtfs.enable = true;
      swclock-offset.enable = true;
      tqftpserv.enable = true;

      udev.extraRules = ''
        ACTION=="remove", GOTO="iio_sensor_proxy_end"

        SUBSYSTEM=="misc", KERNEL=="fastrpc-adsp*", ENV{IIO_SENSOR_PROXY_TYPE}+="ssc-accel ssc-proximity"
        SUBSYSTEM=="misc", KERNEL=="fastrpc-sdsp*", ENV{IIO_SENSOR_PROXY_TYPE}+="ssc-accel ssc-proximity"

        LABEL="iio_sensor_proxy_end"
      '';

      openssh = {
        enable = true;
        openFirewall = lib.mkImageMediaOverride false;
        listenAddresses = [ { addr = config.vanilla-mobile.usb-gadget.network.serverAddress; } ];
        settings = {
          PermitRootLogin = lib.mkImageMediaOverride "yes";
          PasswordAuthentication = lib.mkImageMediaOverride true;
          PermitEmptyPasswords = lib.mkImageMediaOverride true;
          UsePAM = lib.mkImageMediaOverride true;
        };
      };
    };
  };
}
