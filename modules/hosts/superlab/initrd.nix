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
