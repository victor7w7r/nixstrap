{
  den.aspects.superlab.initrd.nixos = {
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
          crypttabExtraOpts = [ "fido2-device=auto" ];
          preLVM = true;
          allowDiscards = true;
        };
      };
    };
  };
}
