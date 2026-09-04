{
  den.aspects.superlab.initrd.nixos = {
    boot.initrd = {
      availableKernelModules = [
        "dm_mod"
        "dm_crypt"
        "encrypted_keys"
        "trusted"
        "aes_arm64"
      ];
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

      systemd.tpm2.enable = false;

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
            "fido2-device=/dev/hidraw0"
            "x-systemd.device-timeout=10"
          ];
          preLVM = true;
          allowDiscards = true;
        };
      };
    };
  };
}
