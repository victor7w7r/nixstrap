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
        "uinput"
        "evdev"
      ];
      extraUtilsCommands = ''
        copy_bin_and_libs ${pkgs.buffyboard}/bin/buffyboard
        cp -a ${pkgs.libinput.out}/share $out/
      '';
      extraUdevRulesCommands = ''
        cp -v ${config.systemd.package}/lib/udev/rules.d/60-input-id.rules $out/
        cp -v ${config.systemd.package}/lib/udev/rules.d/60-persistent-input.rules $out/
        cp -v ${config.systemd.package}/lib/udev/rules.d/70-touchpad.rules $out/
      '';
      preLVMCommands = ''
        mkdir -p /nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-${pkgs.libinput.name}/
        ln -s "$(dirname "$(dirname "$(which buffyboard)")")"/share /nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-${pkgs.libinput.name}/
        buffyboard 2>/dev/null &
      '';
      postMountCommands = "pkill -x buffyboard";
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
