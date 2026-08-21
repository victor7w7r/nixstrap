{
  den.aspects.server.initrd.nixos =
    { lib, pkgs, ... }:
    {
      boot.initrd = {
        supportedFilesystems = lib.mkAfter [ "xfs" ];
        kernelModules = [
          "aesni_intel"
          "ahci"
          "cryptd"
          "dm_crypt"
          "dm_mod"
          "dm_raid"
          "ehci_hcd"
          "encrypted_keys"
          "iptable_nat"
          "overlay"
          "uas"
          "uhci_hcd"
          "usb_storage"
          "usbcore"
          "usbhid"
          "xhci_hcd"
          "xhci_pci"
        ];
    };
}
