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
      getty.autologinUser = "victor7w7r";
      hexagonrpcd.sdsp.enable = true;
      msm-modem-uim-selection.enable = true;
      rmtfs.enable = true;
      swclock-offset.enable = true;
      tqftpserv.enable = true;

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
