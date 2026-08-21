{
  den.aspects.main.initrd.nixos =
    { lib, pkgs, ... }:
    {
      boot.initrd = {
        supportedFilesystems = lib.mkAfter [ "xfs" ];
        kernelModules = [
          "aesni_intel"
          "ahci"
          "apple-bce"
          "brcmfmac"
          "brcmfmac_wcc"
          "cryptd"
          "dm_mod"
          "dm_crypt"
          "dm_raid"
          "ehci-hcd"
          "encrypted_keys"
          "uas"
          "uhci_hcd"
          "usb_storage"
          "usbhid"
          "xhci_hcd"
        ];
        tpm2.enable = false;

        luks.devices =
          let
            partlabel = "/dev/disk/by-partlabel";
            idpart = "/dev/disk/by-id";
          in
          {
            swapcrypt = {
              device = "${partlabel}/disk-ssd-swapcrypt";
              crypttabExtraOpts = [ "fido2-device=auto" ];
              preLVM = true;
            };

            persistcachecrypt = {
              device = "${partlabel}/disk-ssd-persistcachecrypt";
              crypttabExtraOpts = [ "fido2-device=auto" ];
              preLVM = true;
            };

            persist = {
              device = "${idpart}/ata-WDC_WD5000LPSX-75A6WT0_WX12A21JEEPK";
              crypttabExtraOpts = [ "fido2-device=auto" ];
              preLVM = true;
            };

            storage = {
              device = "${idpart}/ata-ST500LT012-1DG142_S3PMCMHT";
              crypttabExtraOpts = [ "fido2-device=auto" ];
              preLVM = true;
            };
          };
      };
    };
}
