{
  den.aspects.superlab.initrd.nixos = { config, pkgs, ... }: {
    boot.initrd = {
      services.udev.packages = [ pkgs.yubikey-personalization ];

      systemd = {
        enable = true;
        tpm2.enable = false;

        storePaths =
          with pkgs;
          (map
            (fw: {
              source = "${config.hardware.firmware}/lib/firmware/${fw}";
              target = "/extra-firmware/${fw}";
            })
            [
              "rtl_nic/rtl8125b-2.fw"
              "arm/mali/arch10.8/mali_csffw.bin"
            ]
          )
          ++ [
            pcsclite.lib
            libfido2
            "${config.boot.initrd.systemd.package}/lib/cryptsetup/libcryptsetup-token-systemd-fido2.so"
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
          crypttabExtraOpts = [ "fido2-device=auto" ];
          allowDiscards = true;
        };
      };
    };
  };
}
