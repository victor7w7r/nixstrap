{
  den.aspects.pizero.initrd.nixos.boot.initrd = {
    kernelModules = [
      "ac200_phy"
      "ahci"
      "configfs"
      "display_connector"
      "dm_crypt"
      "dm_mod"
      "ehci_hcd"
      "encrypted_keys"
      "musb_hdrc"
      "panfrost"
      "phy_generic"
      "phy_sun4i_usb"
      "sprdbt_tty"
      "sprdwl_ng"
      "sun50i_h6_prcm_ppu"
      "sun8i_ce"
      "sunxi"
      "sunxi_addr"
      "uas"
      "uhci_hcd"
      "usb_storage"
      "usbcore"
      "usbhid"
      "xhci_hcd"
      "xhci_pci"
    ];

    systemd.tpm2.enable = false;

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
}
