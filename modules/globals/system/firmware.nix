{
  den.default.nixos =
    {
      isPhone,
      isX86,
      lib,
      pkgs,
      ...
    }:
    {
      nixpkgs.overlays = [
        (final: prev: {
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
          makeModulesClosure = x: prev.makeModulesClosure (x // { allowMissing = true; });
          mbrola-voices = prev.mbrola-voices.override { languages = [ "*1" ]; };
        })
      ];

      hardware = {
        enableRedistributableFirmware = lib.mkForce false;
        wirelessRegulatoryDatabase = true;
        firmware = with pkgs; lib.singleton linux-firmware;
      };
    };
}
