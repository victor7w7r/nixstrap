{
  den.aspects.handheld.initrd.nixos =
    { lib, ... }:
    {
      boot.initrd = {
        kernelModules = [
          "dm-snapshot"
          "kvm-amd"
          "amdgpu"
          "snd_usb_audio"
          "snd_hda_intel"
          "xhci_pci"
          "nvme"
          "thunderbolt"
          "usb_storage"
          "usbhid"
          "sd_mod"
          "sdhci_pci"
          "zram"
        ];

        luks.devices.swapcrypt = {
          device = "/dev/disk/by-partlabel/disk-main-swapcrypt";
          crypttabExtraOpts = [ "tpm2-device=auto" ];
          preLVM = true;
        };
      };
    };
}
