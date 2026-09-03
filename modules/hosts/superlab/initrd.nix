{
  den.aspects.superlab.initrd.nixos = { config, ... }: {
    boot.initrd = {
      kernelModules = [
        "display_connector"
        "dm_crypt"
        "dm_mod"
        "rng_core"
        "rockchip_rng"
        "rockchipdrm"
        "spi_rockchip_sfc"
        "uas"
        "usbhid"
        #"rk_crypto2"
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
