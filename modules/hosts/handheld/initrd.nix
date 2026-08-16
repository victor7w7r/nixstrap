{
  den.aspects.handheld.initrd.nixos = {
    boot.initrd = {
      availableKernelModules = [
        "snd_hda_scodec_cs35l41_i2c"
        "snd_soc_cs35l41_i2c"
      ];
      kernelModules = [
        "amdgpu"
        "cryptd"
        "dm_mod"
        "dm_crypt"
        "encrypted_keys"
        "snd_hda_intel"
        "usbhid"
      ];

      luks.devices.swapcrypt = {
        device = "/dev/disk/by-partlabel/disk-main-swapcrypt";
        crypttabExtraOpts = [ "fido2-device=auto" ];
      };
    };
  };
}
