{
  den.aspects.main.initrd.nixos =
    { lib, ... }:
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
          "dm_crypt"
          "dm_mod"
          "dm_raid"
          "ehci-hcd"
          "encrypted_keys"
          "kvm_intel"
          "kvmfr"
          "kvmgt"
          "mdev"
          "uas"
          "uhci_hcd"
          "usb_storage"
          "usbhid"
          "xhci_hcd"
          "vfio"
          "vfio_iommu_type1"
          "vfio_pci"
        ];
        systemd.tpm2.enable = false;

        luks.devices =
          let
            partlabel = "/dev/disk/by-partlabel";
            idpart = "/dev/disk/by-id";
          in
          {
            swapcrypt = {
              device = "${partlabel}/disk-ssd-swapcrypt";
              crypttabExtraOpts = [ "fido2-device=auto" ];
              allowDiscards = true;
              preLVM = true;
            };

            persistcachecrypt = {
              device = "${partlabel}/disk-ssd-persistcachecrypt";
              crypttabExtraOpts = [ "fido2-device=auto" ];
              allowDiscards = true;
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
