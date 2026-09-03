{
  den.aspects.superlab.initrd.nixos = { config, ... }: {
    boot.initrd = {
      availableKernelModules = [
        "dm_crypt"
        "dm_mod"
        "aes_ce_cipher"
        "aes_arm64"
        "sm3_ce"
        "sm3_generic"
        "essiv"
      ];

      kernelModules = [
        "display_connector"
        "rng_core"
        "rockchipdrm"
        "spi_rockchip_sfc"
        "uhid"
        "usbhid"
        "rk_crypto2"
        "rockchip_rng"
        "sg"
        "trusted"
      ];

      systemd = {
        tpm2.enable = false;
        storePaths = (
          map
            (fw: {
              source = "${config.hardware.firmware}/lib/firmware/${fw}";
              target = "/extra-firmware/${fw}";
            })
            [
              "rtl_nic/rtl8125b-2.fw"
              "arm/mali/arch10.8/mali_csffw.bin"
            ]
        );
      };

      luks.devices = {
        /*
          swapcrypt = {
          device = "/dev/disk/by-partlabel/disk-main-swapcrypt";
          crypttabExtraOpts = [ "fido2-device=auto" ];
          };
        */
        system = {
          device = "/dev/disk/by-partlabel/disk-main-system";
          crypttabExtraOpts = [ "fido2-device=auto" ];
          preLVM = true;
          allowDiscards = true;
        };
      };
    };
  };
}
