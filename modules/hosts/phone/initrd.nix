{
  den.aspects.phone.services.nixos =
    {
      config,
      pkgs,
      self',
      ...
    }:
    {
      boot.initrd = {
        includeDefaultModules = false;
        availableKernelModules = [ "sd_mod" ];
        kernelModules = [
          "dm_mod"
          "qcom_pd_mapper"
          "qcom_spmi_haptics"
          "rmi_i2c"
          "ufs-qcom"
          "ufshcd-core"
        ];

        services.udev.packages = [
          config.systemd.package
          pkgs.libinput
        ];

        systemd = {
          enable = true;
          package = pkgs.systemd;
          tpm2.enable = false;
          services = {
            save-initrd-log = {
              wantedBy = [
                "emergency.target"
                "rescue.target"
              ];
              before = [ "emergency.service" ];

              unitConfig.DefaultDependencies = false;

              script = ''
                mkdir -p /mnt/efi
                if ${pkgs.util-linux}/bin/mount -t vfat /dev/disk/by-partlabel/system_a /mnt/efi 2>/dev/null; then
                  ${pkgs.systemd}/bin/journalctl -b > /mnt/efi/initrd-journal.txt
                  sync
                  ${pkgs.util-linux}/bin/umount /mnt/efi
                fi
              '';

              serviceConfig = {
                Type = "oneshot";
                RemainAfterExit = true;
              };
            };
          };
          storePaths = [
            "${self'.packages.buffyboard}/bin/buffyboard"
            "${pkgs.libinput.out}/share"
          ]
          ++
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
