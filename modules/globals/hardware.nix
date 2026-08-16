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

        nixpkgs.overlays = [
          (final: prev: {
            makeModulesClosure = x: prev.makeModulesClosure (x // { allowMissing = true; });
            mbrola-voices = prev.mbrola-voices.override { languages = [ "*1" ]; };
            linux-firmware = (
              prev.linux-firmware.overrideAttrs (o: {
                postInstall = ''
                  rm -rf "$out"/lib/firmware/intel/iwlwifi
                  rm -rf "$out"/lib/firmware/{ath11k,ath12k,libertas,nvidia,cxgb4,ti-connectivity,cypress,xe}
                  rm -rf "$out"/lib/firmware/{mellanox,mrvl,netronome,dpaa2,qed,bnx2x,liquidio,rtw89,dpaa2,dell,LENOVO}
                  find "$out/lib/firmware" -xtype l -print -delete
                '';
              })
            );
          })
        ];

        hardware = lib.mkMerge [
          (lib.mkIf isGraphic { graphics.enable = true; })
          (lib.mkIf (isGraphic && isX86) { graphics.enable32Bit = true; })
          {
            wirelessRegulatoryDatabase = true;
            sensor.iio.enable = true;
            ksm.enable = true;
            #sensor.hddtemp.enable = true; SPECIFICATE IN HOSTS with .drives
            enableRedistributableFirmware = lib.mkForce false;
            firmware = with pkgs; [ linux-firmware ];
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
