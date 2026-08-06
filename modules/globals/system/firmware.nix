{
  den.default.nixos =
    {
      isX86,
      lib,
      pkgs,
      ...
    }:
    {
      nixpkgs.overlays = [
        (final: prev: {
          linux-firmware = lib.optionalAttrs isX86 (
            prev.linux-firmware.overrideAttrs (o: {
              postInstall = ''
                rm -rf "$out"/lib/firmware/intel/iwlwifi
                rm -rf "$out"/lib/firmware/{qcom,ath11k,ath10k,ath12k,libertas,nvidia,cxgb4,ti-connectivity}
                rm -rf "$out"/lib/firmware/{mellanox,mrvl,netronome,dpaa2,qed,bnx2x,liquidio,rtw89,dpaa2,dell,LENOVO}
                rm -rf "$out"/lib/firmware/{cypress,xe,i}
                find "$out/lib/firmware" -xtype l -print -delete
              '';
            })
          );
          makeModulesClosure = x: prev.makeModulesClosure (x // { allowMissing = true; });
          mbrola-voices = prev.mbrola-voices.override { languages = [ "*1" ]; };
        })
      ];

      hardware = {
        enableRedistributableFirmware = true;
        firmware =
          with pkgs;
          lib.optionals [
            linux-firmware
            /*
              rtl8192su-firmware
              rtl8761b-firmware
            */
          ];
      };
    };
}
