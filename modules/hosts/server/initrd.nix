{
  den.aspects.server.initrd.nixos =
    { lib, ... }:
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

        luks.devices =
          let
            partlabel = "/dev/disk/by-partlabel";
          in
          {
            bcache = {
              device = "/dev/bcache0";
              crypttabExtraOpts = [ "fido2-device=auto" ];
              preLVM = true;
            };

            swapcrypt = {
              device = "${partlabel}/disk-nvme-swapcrypt";
              crypttabExtraOpts = [ "fido2-device=auto" ];
              allowDiscards = true;
              preLVM = true;
            };

            cloudlogcrypt = {
              device = "${partlabel}/disk-nvme-cloudlogcrypt";
              crypttabExtraOpts = [ "fido2-device=auto" ];
              preLVM = true;
            };

            cloudcachecrypt = {
              device = "${partlabel}/disk-nvme-cloudcachecrypt";
              crypttabExtraOpts = [ "fido2-device=auto" ];
              allowDiscards = true;
              preLVM = true;
            };

            persist = {
              device = "${partlabel}/disk-nvme-persist";
              crypttabExtraOpts = [ "fido2-device=auto" ];
              preLVM = true;
            };
          };
      };
    };
}
