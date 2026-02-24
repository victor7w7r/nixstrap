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

  asusPatches = builtins.map (p: "${g14patch.outPath}") [
    "0001-bluetooth-btus-add-new-vid-pid.patch"
    "0001-platform-x86-asus-armoury-Fix-error-code-in-mini_led.patch"
    "0001-platform-x86-asus-armoury-fix-only-DC-tunables-being.patch"
    "0001-platform-x86-asus-wmi-export-symbols-used-for-read-w.patch"
    "0001-platform-x86-asus-wmi-fix-initializing-TUFs-keyboard.patch"
    "0002-platform-x86-asus-armoury-add-keyboard-control-firmw.patch"
    "0002-platform-x86-asus-armoury-fix-mini-led-mode-show.patch"
    "0002-platform-x86-asus-armoury-move-existing-tunings-to-a.patch"
    "0003-0-3-asus-armoury-add-support-for-GV302XV-FA401UV-FA617XT.patch"
    "0003-0-4-platform-x86-asus-armoury-ppt-fixes-and-new-models.patch"
    "0003-platform-x86-asus-armoury-add-panel_hd_mode-attribut.patch"
    "0003-platform-x86-asus-armoury-add-support-for-FA507UV.patch"
    "0003-platform-x86-asus-armoury-add-support-for-FA608UM.patch"
    "0003-platform-x86-asus-armoury-add-support-for-G615LR.patch"
    "0003-platform-x86-asus-armoury-add-support-for-G835LW.patch"
    "0003-platform-x86-asus-armoury-add-support-for-GA403WR.patch"
    "0003-platform-x86-asus-armoury-add-support-for-GU605CR.patch"
    "0004-platform-x86-asus-armoury-add-apu-mem-control-suppor.patch"
    "0005-platform-x86-asus-armoury-add-screen-auto-brightness.patch"
    "0006-platform-x86-asus-wmi-deprecate-bios-features.patch"
    "0007-platform-x86-asus-wmi-rename-ASUS_WMI_DEVID_PPT_FPPT.patch"
    "0008-platform-x86-asus-armoury-add-ppt_-and-nv_-tuning-kn.patch"
    "0010-platform-x86-asus-wmi-move-keyboard-control-firmware.patch"
    "0040-workaround_hardware_decoding_amdgpu.patch"
    "0070-acpi-x86-s2idle-Add-ability-to-configure-wakeup-by-A.patch"
    "0081-amdgpu-adjust_plane_init_off_by_one.patch"
    "0084-enable-steam-deck-hdr.patch"
    "asus-patch-series.patch"
    "ga403wr-fix-audio.patch"
    "PATCH-asus-wmi-fixup-screenpad-brightness.patch"
    "PATCH-v4-1-3-platform-x86-asus-wmi-explicitly-mark-more-code-with-CONFIG_ASUS_WMI_DEPRECATED_ATTRS.patch"
    "PATCH-v5-00-11-Improvements-to-S5-power-consumption.patch"
    "PATCH-v10-00-11-HID-asus-Fix-ASUS-ROG-Laptop-s-Keyboard-backlight-handling-id1-id2-pr_err.patch"
    "PATCH-v10-00-11-HID-asus-Fix-ASUS-ROG-Laptop-s-Keyboard-backlight-handling.patch"
    "PATCH-v11-00-11-HID-asus-Fix-ASUS-ROG-Laptop-s-Keyboard-backlight-handling.patch"
    "sys-kernel_arch-sources-g14_files-0004-more-uarches-for-kernel-6.15.patch"
    "sys-kernel_arch-sources-g14_files-0047-asus-nb-wmi-Add-tablet_mode_sw-lid-flip.patch"
    "sys-kernel_arch-sources-g14_files-0048-asus-nb-wmi-fix-tablet_mode_sw_int.patch"
    "v2-0002-hid-asus-change-the-report_id-used-for-HID-LED-co.patch"
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
      install -Dm644 ${kconfigClearence} arch/x86/configs/cachyos_defconfig
    '';
  };
}
