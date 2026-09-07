{
  den.aspects.superlab.initrd.nixos = { pkgs, ... }: {
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

      services.udev.packages = with pkgs; [
        libfido2
        yubikey-personalization
      ];

      services.udev.rules = ''
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1050", MODE="0402", TAG+="uaccess"
      '';

      systemd = {
      	enable = true;
        tpm2.enable = false;
        fido2.enable = true;
      };

      luks.devices = {
        /*
          swapcrypt = {
          device = "/dev/disk/by-partlabel/disk-main-swapcrypt";
          crypttabExtraOpts = [ "fido2-device=auto" ];
          };
        */
        system = {
          device = "/dev/disk/by-uuid/7ee55551-ef11-4d13-8613-04f37595f6f3";
          crypttabExtraOpts = [
            "fido2-device=auto"
            "x-systemd.device-timeout=45"
          ];
          allowDiscards = true;
        };
      };
    };
  };
}
