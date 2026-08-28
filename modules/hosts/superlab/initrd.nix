{
  den.aspects.superlab.initrd.nixos = { config, ... }: {
    boot.initrd = {
      systemd = {
        tpm2.enable = false;
        storePaths =
          map
            (fw: {
              source = "${config.hardware.firmware}/lib/firmware/${fw}";
              target = "/extra-firmware/${fw}";
            })
            [
              "rtl_nic/rtl8125b-2.fw"
              "arm/mali/arch10.8/mali_csffw.bin"
            ];
      };
      kernelModules = [
        "display_connector"
        "dm_crypt"
        "dm_mod"
        "rng_core"
        "rockchipdrm"
        "spi_rockchip_sfc"
        "uhid"
        "usbhid"
        #"rk_crypto2"
        #"rockchip_rng"
        #"sg"
        #"sm3_generic"
        #"trusted"
        #"resume=${config.boot.resumeDevice}"
      ];

      luks.devices = {
        /*
          swapcrypt = {
          device = "/dev/disk/by-partlabel/disk-main-swapcrypt";
          crypttabExtraOpts = [ "fido2-device=auto" ];
          };
        */
        system = {
          device = "/dev/disk/by-partlabel/disk-main-system";
          crypttabExtraOpts = [
            "fido2-device=auto"
            "x-systemd.device-timeout=30s"
          ];
        };
      };
    };
  };
}
