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
          linux-firmware = lib.optionalAttrs isX86 prev.linux-firmware.overrideAttrs (o: {
            postInstall = ''
              rm -rf "$out"/lib/firmware/{netronome,qcom,mellanox,mrvl,ath11k,ath10k,libertas,nvidia,liquidio,cxgb4,ti-connectivity,qed}
              find -L "$out" -type l -delete
            '';
          });
          makeModulesClosure = x: prev.makeModulesClosure (x // { allowMissing = true; });
          mbrola-voices = prev.mbrola-voices.override { languages = [ "*1" ]; };
        })
      ];

      hardware = lib.optionalAttrs isX86 {
        enableAllFirmware = lib.mkForce false;
        enableRedistributableFirmware = lib.mkForce false;

        firmware = with pkgs; [
          linux-firmware
          /*
            rtl8192su-firmware
            rtl8761b-firmware
          */
        ];
      };
    };
}
