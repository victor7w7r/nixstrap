{
  den.aspects.pizero.initrd.nixos = { config, ... }: {
    boot.initrd = {
      kernelModules = [
        "ac200_phy"
        "ahci"
        "configfs"
        "display_connector"
        "dm_crypt"
        "dm_mod"
        "musb_hdrc"
        "panfrost"
        "phy_generic"
        #"sprdbt_tty"
        #"sprdwl_ng"
        "sun50i_h6_prcm_ppu"
        "sunxi"
        "sunxi_addr"
        "sun4i-gpadc-iio"
        "uas"
        "uhci_hcd"
        "usbhid"
      ];

      systemd = {
        tpm2.enable = false;
        storePaths =
          map
            (fw: {
              source = "${config.hardware.firmware}/lib/firmware/uwe5622/${fw}";
              target = "/extra-firmware/uwe5622/${fw}";
            })
            [
              "wcnmodem-38222.bin"
              "wcnmodem.bin"
              "wifi_2355b001_1ant.ini"
            ];
      };

      luks.devices = {
        swapcrypt = {
          device = "/dev/disk/by-partlabel/disk-sda-swapcrypt";
          crypttabExtraOpts = [ "fido2-device=auto" ];
          preLVM = true;
        };
        system = {
          device = "/dev/disk/by-partlabel/disk-main-system";
          crypttabExtraOpts = [ "fido2-device=auto" ];
          preLVM = true;
        };
      };
    };
  };
}
