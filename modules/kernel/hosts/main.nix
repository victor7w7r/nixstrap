{ lib, kernel, ... }:
{
  kernel.hosts.main =
    pkgs: armCross:
    (kernel.lib.linux {
      inherit pkgs;
      localVer = "native";
      patches = with kernel.patches.injector pkgs; cachyos.std ++ tachyon.std ++ bunker.std;
      structuredExtraConfig = with lib.kernel; {
        BCACHE = yes;
        BLK_DEV_NVME = yes;
        BLK_DEV_SD = yes;
        BT_RFCOMM = yes;
        BT_HCIUART = yes;
        CC_OPTIMIZE_FOR_PERFORMANCE = no;
        CC_OPTIMIZE_FOR_PERFORMANCE_O3 = yes;
        ECRYPT_FS = yes;
        ECRYPT_FS_MESSAGING = yes;
        EFIVAR_FS = yes;
        ENCRYPTED_KEYS = yes;
        EXPERT = yes;
        HZ_PERIODIC = no;
        I2C_ALGOBIT = yes;
        I2C_CHARDEV = yes;
        I2C_SMBUS = yes;
        INPUT_EVDEV = yes;
        IOMMUFD = yes;
        KVM = yes;
        KEYBOARD_ATKBD = yes;
        LEGACY_VSYSCALL_NONE = yes;
        LTO_CLANG_FULL = no;
        LTO_CLANG_THIN = yes;
        LTO_NONE = no;
        MAGIC_SYSRQ_DEFAULT_ENABLE = freeform "0x84";
        NLS_CODEPAGE_437 = yes;
        NLS_ISO8859_1 = yes;
        NO_HZ = yes;
        NO_HZ_COMMON = yes;
        PCIE_BUS_PERFORMANCE = yes;
        PCI_REALLOC_ENABLE_AUTO = yes;
        PREEMPT_LAZY = no;
        PSTORE_RAM = yes;
        RESET_ATTACK_MITIGATION = yes;
        RFKILL = yes;
        SCSI = yes;
        SECURITY_LOCKDOWN_LSM = yes;
        SERIO = yes;
        SQUASHFS = yes;
        TEE = yes;
        TLS = yes;
        TRANSPARENT_HUGEPAGE_ALWAYS = no;
        TRANSPARENT_HUGEPAGE_MADVISE = yes;
        TRUSTED_KEYS = yes;
      };
      extraConfig = with kernel.config.modules; [
        default
        freq.high
        hardware.desktop
        hardware.native
        hardware.serial
        net
        storage.ntfs
        storage.raid
        storage.xfs
        vendor.intel
        {
          BRCMFMAC = "y";
          EEPROM_EE1004 = "y";
          SND_HDA_CODEC_HDMI_INTEL = "m";
          SND_HDA_INTEL = "y";
          SND_SOC_INTEL_AVS = "y";
          SND_USB_AUDIO = "y";
          UINPUT = "y";
        }
      ];
    })
    |> (generated: {
      main-kernelPackages = generated.packages;
      main-kernel = generated.kernel;
      main-config = generated.config;
    });

  perSystem =
    { pkgs, ... }:
    kernel.lib.package-gen {
      inherit pkgs;
      host = "main";
      cross = "x86_64-unknown-linux-gnu";
    };
}
