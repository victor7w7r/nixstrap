{
  den.aspects.pizero.initrd.nixos = { self', ... }: {
    systemd.tmpfiles.rules = [
      "L+ /lib/firmware/wcnmodem.bin - - - - /lib/firmware/uwe5622/wcnmodem.bin"
    ];

    boot.initrd = {
      extraFiles = {
        "/lib/firmware/uwe5622/wcnmodem.bin".source = "${self'.packages.armbian-firmware}/lib/firmware/uwe5622/wcnmodem.bin";
        "/lib/firmware/wcnmodem.bin".source = "${self'.packages.armbian-firmware}/lib/firmware/uwe5622/wcnmodem.bin";
      };

      kernelModules = [
        "ac200_phy"
        "ahci"
        "dm_crypt"
        "dm_mod"
        "musb_hdrc"
        "phy_generic"
        "sprdbt_tty"
        "sprdwl_ng"
        "sun50i_h6_prcm_ppu"
        "sunxi"
        "sunxi_addr"
        "uas"
        "usbhid"
      ];

      systemd.tpm2.enable = false;

      luks.devices = {
        swapcrypt = {
          device = "/dev/disk/by-partlabel/disk-sda-swapcrypt";
          crypttabExtraOpts = [ "fido2-device=auto" ];
          preLVM = true;
          allowDiscards = true;
        };
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
