{
  host,
  pkgs,
  lib,
  ...
}:
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

  hardware = {
    enableAllFirmware = lib.mkForce false;
    enableRedistributableFirmware = lib.mkForce false;
    firmware = with pkgs; [
      linux-firmware
      rtl8192su-firmware
      rtl8761b-firmware
    ];
    ksm.enable = true;
    #sensor.hddtemp.enable = true; SPECIFICATE IN HOSTS with .drives
    bluetooth = {
      enable = (host != "v7w7r-nixvm");
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          FastConnectable = "true";
          JustWorksRepairing = "always";
          MultiProfile = "multiple";
          Experimental = true;
        };
      };
    };
  };

  programs = {
    corectrl.enable = true;
    #corefreq.enable = true;
    iotop.enable = true;
    usbtop.enable = true;
    coolercontrol.enable = host != "v7w7r-youyeetoox1";
  };
}
