{
  den.aspects.handheld.initrd.nixos = {
    boot.initrd = {
      availableKernelModules = [
        "snd_hda_scodec_cs35l41_i2c"
        "snd_soc_cs35l41_i2c"
      ];
      kernelModules = [
        "dm-snapshot"
        "kvm-amd"
        "amdgpu"
        "snd_usb_audio"
        "snd_hda_intel"
        "xhci_pci"
        "nvme"
        "usb_storage"
        "usbhid"
        "sd_mod"
        "sdhci_pci"
      ];

      luks.devices.swapcrypt = {
        device = "/dev/disk/by-partlabel/disk-main-swapcrypt";
        crypttabExtraOpts = [ "tpm2-device=auto" ];
        preLVM = true;
      };
    };
  };
}
