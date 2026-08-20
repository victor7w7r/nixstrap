{
  den.aspects.handheld.initrd.nixos.boot.initrd = {
    availableKernelModules = [
      "dm_crypt"
      "dm_mod"
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

    luks.devices = {
      swapcrypt = {
        device = "/dev/disk/by-partlabel/disk-main-swapcrypt";
        crypttabExtraOpts = [ "fido2-device=auto" ];
      };
      system = {
        device = "/dev/disk/by-partlabel/disk-main-system";
        crypttabExtraOpts = [ "fido2-device=auto" ];
      };
    };
  };
}
