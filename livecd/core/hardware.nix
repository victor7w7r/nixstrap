{ pkgs, lib, ... }:
{
  nixpkgs.overlays = [
    (pkgs: prev: {
      linux-firmware = prev.linux-firmware.overrideAttrs (o: {
        postInstall = ''
          rm -rf "$out"/lib/firmware/{netronome,qcom,mellanox,mrvl,ath11k,ath10k,libertas,nvidia,liquidio,cxgb4,ti-connectivity,qed}
          find -L "$out" -type l -delete
        '';
      });
    })
  ];

  hardware = with lib; {
    bluetooth = {
      enable = true;
      settings.General = {
        Enable = "Source,Sink,Media,Socket";
        FastConnectable = "true";
        JustWorksRepairing = "always";
        MultiProfile = "multiple";
      };
    };
    enableAllFirmware = mkForce false;
    enableRedistributableFirmware = mkForce false;
    firmware = with pkgs; [
      linux-firmware
      rtl8192su-firmware
      rtl8761b-firmware
    ];
    cpu = {
      amd.updateMicrocode = true;
      intel.updateMicrocode = true;
    };
  };
}
