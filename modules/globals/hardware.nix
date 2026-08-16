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
            linux-firmware = prev.linux-firmware.overrideAttrs (oldAttrs: {
              postInstall = (oldAttrs.postInstall or "") + ''
                rm -rf $out/lib/firmware/intel/iwlwifi
                rm -rf $out/lib/firmware/ath11k $out/lib/firmware/ath12k $out/lib/firmware/libertas
                rm -rf $out/lib/firmware/nvidia $out/lib/firmware/cxgb4 $out/lib/firmware/ti-connectivity
                rm -rf $out/lib/firmware/cypress $out/lib/firmware/xe $out/lib/firmware/mellanox
                rm -rf $out/lib/firmware/mrvl $out/lib/firmware/netronome $out/lib/firmware/dpaa2
                rm -rf $out/lib/firmware/qed $out/lib/firmware/bnx2x $out/lib/firmware/liquidio
                rm -rf $out/lib/firmware/rtw89 $out/lib/firmware/dell $out/lib/firmware/LENOVO

                find $out/lib/firmware -xtype l -print -delete
              '';
            });
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
