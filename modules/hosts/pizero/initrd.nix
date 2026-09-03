{
  den.aspects.pizero.initrd.nixos = {
    boot.initrd = {
      kernelModules = [
        "ac200_phy"
        "ahci"
        "dm_crypt"
        "dm_mod"
        "musb_hdrc"
        "phy_generic"
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
