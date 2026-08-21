{
  den.aspects.phone.services.nixos = { config, pkgs, ... }: {
    boot.initrd = {
      includeDefaultModules = false;
      availableKernelModules = [ "sd_mod" ];
      kernelModules = [
        "dm_mod"
        "i2c_qcom_geni"
        "rmi_core"
        "rmi_i2c"
        "qcom_spmi_haptics"
      ];
      systemd = {
        enable = true;
        package = pkgs.systemd;
        tpm2.enable = false;
        storePaths =
          map
            (fw: {
              source = "${config.hardware.firmware}/lib/firmware/${fw}.zst";
              target = "/extra-firmware/${fw}.zst";
            })
            [
              "qcom/sdm845/OnePlus/enchilada/adsp.mbn"
              "qcom/sdm845/OnePlus/enchilada/cdsp.mbn"
              "qcom/sdm845/OnePlus/enchilada/ipa_fws.mbn"
              "qcom/sdm845/OnePlus/enchilada/a630_zap.mbn"
              "qcom/sdm845/OnePlus/enchilada/slpi.mbn"
              "ath10k/WCN3990/hw1.0/board-2.bin"
              "qca/crbtfw21.tlv"
              "qca/crnv21.bin"
              "qca/OnePlus/enchilada/crnv21.bin"
              "qcom/a630_sqe.fw"
              "qcom/a630_gmu.bin"
            ];
      };
    };
  };
}
