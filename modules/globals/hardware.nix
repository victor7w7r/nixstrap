{
  den.default = {
    os =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          cpulimit
          cyme
          edid-generator
          pciutils
          usbutils
        ];
      };

    nixos =
      {
        isGraphic,
        isX86,
        lib,
        pkgs,
        ...
      }:
      {
        environment.systemPackages = with pkgs; [
          dippi
          dmidecode
          edid-decode
          fanctl
          fan2go
          hwinfo
          i2c-tools
          iio-sensor-proxy
          lm_sensors
          lshw
          read-edid
          rwedid
        ];

        hardware = lib.mkMerge [
          (lib.mkIf isGraphic { graphics.enable = true; })
          (lib.mkIf (isGraphic && isX86) { graphics.enable32Bit = true; })
          {
            wirelessRegulatoryDatabase = true;
            sensor.iio.enable = true;
            ksm.enable = true;
            #sensor.hddtemp.enable = true; SPECIFICATE IN HOSTS with .drives
          }
        ];
        services = {
          power-profiles-daemon.enable = lib.mkForce true;
          tlp.enable = lib.mkForce false;
          smartd.enable = false;
        };
        programs = {
          corectrl.enable = true;
          #corefreq.enable = true;
          iotop.enable = true;
          usbtop.enable = true;
          #coolercontrol.enable = host != "v7w7r-youyeetoox1";
        };
      };
  };
}
