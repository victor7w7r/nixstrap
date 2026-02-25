{
  lib,
  src,
  version,
  inputs,
  configVariant,
  kernelPatches,
  applyPatches,
  runCommand,
  cpusched ? "bore",
  asus ? false,
  hardened ? false,
  acpiCall ? false,
  handheld ? false,
  ...
}:
let
  cachyosConfigFile = "${inputs.cachyos-kernel.outPath}/${configVariant}/config";
  cachyosPatches =
    builtins.map (p: "${inputs.cachyos-kernel-patches.outPath}/${lib.versions.majorMinor version}/${p}")
      (
        [ "all/0001-cachyos-base-all.patch" ]
        ++ (lib.optional (cpusched == "bore") "sched/0001-bore-cachy.patch")
        ++ (lib.optional hardened "misc/0001-hardened.patch")
        ++ (lib.optional acpiCall "misc/0001-acpi-call.patch")
        ++ (lib.optional handheld "misc/0001-handheld.patch")
      );
  g14patch = fetchGit {
    url = "https://gitlab.com/asus-linux/linux-g14";
    ref = "6.18";
    rev = "52ac92f9b6085f3b2c7edac93dec412dbe9c01b4";
  };

  asusPatches = builtins.map (name: "${g14patch}/${name}") [
    "0001-acpi-proc-idle-skip-dummy-wait.patch"
    #"0001-HID-asus-fix-more-n-key-report-descriptors-if-n-key-.patch"
    #"0002-HID-asus-make-asus_kbd_init-generic-remove-rog_nkey_.patch"
    #"0002-platform-x86-asus-wmi-don-t-fail-if-platform_profile.patch"
    #"0003-asus-bios-refactor-existing-tunings-in-to-asus-bios-.patch"
    #"0003-HID-asus-add-ROG-Ally-N-Key-ID-and-keycodes.patch"
    #"0003-platform-x86-asus-wmi-add-macros-and-expose-min-max-.patch"
    #"0004-asus-bios-add-panel-hd-control.patch"
    #"0005-asus-wmi-don-t-error-out-if-platform_profile-already.patch"
    #"0006-asus-bios-add-apu-mem.patch"
    #"0007-asus-bios-add-core-count-control.patch"
    "0027-mt76_-mt7921_-Disable-powersave-features-by-default.patch"
    "0032-Bluetooth-btusb-Add-a-new-PID-VID-0489-e0f6-for-MT7922.patch"
    #"0035-Add_quirk_for_polling_the_KBD_port.patch"
    "0038-mediatek-pci-reset.patch"
    "0040-workaround_hardware_decoding_amdgpu.patch"
    #"v2-0001-hid-asus-use-hid-for-brightness-control-on-keyboa.patch"
    "v2-0005-platform-x86-asus-wmi-don-t-allow-eGPU-switching-.patch"
    "v4-0004-platform-x86-asus-wmi-support-toggling-POST-sound.patch"
    "v4-0005-platform-x86-asus-wmi-store-a-min-default-for-ppt.patch"
    "v4-0006-platform-x86-asus-wmi-adjust-formatting-of-ppt-na.patch"
    "v4-0007-platform-x86-asus-wmi-ROG-Ally-increase-wait-time.patch"
    "v4-0008-platform-x86-asus-wmi-Add-support-for-MCU-powersa.patch"
    "v4-0009-platform-x86-asus-wmi-cleanup-main-struct-to-avoi.patch"
  ];

  kconfigClearence = runCommand "kconfig-hack" { } ''
    cp "${cachyosConfigFile}" config
    sed -i '/^#/d' config
    sed -i '/^CONFIG_G*CC_/d' config
    sed -i '/^CONFIG_LD_/d' config
    sed -i '/^CONFIG_RUSTC*_/d' config
    sed -i '/^CONFIG_CC_/d' config
    sed -i '/^CONFIG_KUNIT$/d' config
    sed -i '/^CONFIG_RUNTIME_TESTING_MENU/d' config
    # remove drivers as they are defined in structured config
    sed -i '/^CONFIG_SND_/d' config
    # sed -i '/^CONFIG_NET_/d' config
    sed -i '/^CONFIG_.*_FS=/d' config
    sed -i '/^CONFIG_MMC_/d' config
    sed -i '/^CONFIG_MEMSTICK_/d' config
    sed -i '/^CONFIG_SYSTEM/d' config
    sed -i '/^CONFIG_MEDIA_/d' config
    sed -i '/^CONFIG_SSB/d' config
    sed -i '/^CONFIG_IIO/d' config
    sed -i '/^CONFIG_USB_/d' config
    # sed -i '/^CONFIG_PHY_/d' config
    # sed -i '/^CONFIG_DRM_/d' config
    # sed -i '/^CONFIG_FB_/d' config
    sed -i '/^CONFIG_MFD_/d' config
    sed -i '/^CONFIG_GPIO/d' config
    sed -i '/^CONFIG_REGULATOR/d' config
    sed -i '/^CONFIG_COMEDI/d' config
    # sed -i '/^CONFIG_SENSORS/d' config
    sed -i '/^CONFIG_BLK_DEV/d' config
    sed -i '/^CONFIG_SCSI_/d' config
    sed -i '/^CONFIG_DEBUG_/d' config
    sed -i '/^CONFIG_.*_PHY=/d' config
    sed -i '/^CONFIG_INPUT_/d' config
    sed -i '/^CONFIG_JOYSTICK_/d' config
    sed -i '/^CONFIG_PTP_1588_CLOCK/d' config
    sed -i '/^CONFIG_ATH/d' config
    # AI: merge multiple empty lines into one
    sed -i '/^$/N;/\n$/D' config
    cp config "$out"
  '';
in
{
  inherit cachyosConfigFile cachyosPatches;
  patchedSrc = applyPatches {
    name = "linux-src-patched";
    inherit src;
    patches = [
      kernelPatches.bridge_stp_helper.patch
      kernelPatches.request_key_helper.patch
    ]
    ++ (lib.optional asus asusPatches)
    ++ cachyosPatches;
    postPatch = ''
      install -Dm644 ${cachyosConfigFile} arch/x86/configs/cachyos_defconfig
    '';
  };
}
