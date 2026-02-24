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

  asusPatches = builtins.map (p: "${inputs.asus-patches.outPath}") [
    "sys-kernel_arch-sources-g14_files-0004-5.8+--more-uarches-for-kernel.patch"
    "sys-kernel_arch-sources-g14_files-0005-lru-multi-generational.patch"
    "sys-kernel_arch-sources-g14_files-0006-zstd.patch"
    "sys-kernel_arch-sources-g14_files-0039-asus-wmi-Add-panel-overdrive-functionality.patch"
    "sys-kernel_arch-sources-g14_files-0043-ALSA-hda-realtek-Fix-speakers-not-working-on-Asus-Fl.patch"
    "sys-kernel_arch-sources-g14_files-0044-claymore.patch"
    "sys-kernel_arch-sources-g14_files-0045-v5-asus-wmi-Add-support-for-platform_profile.patch"
    "sys-kernel_arch-sources-g14_files-0046-fan-curvers.patch"
    "sys-kernel_arch-sources-g14_files-0047-asus-nb-wmi-Add-tablet_mode_sw-lid-flip.patch"
    "sys-kernel_arch-sources-g14_files-0048-asus-nb-wmi-Allow-configuring-SW_TABLET.patch"
    "sys-kernel_arch-sources-g14_files-0048-asus-nb-wmi-fix-tablet_mode_sw_int.patch"
    "sys-kernel_arch-sources-g14_files-8002-hwmon-k10temp-support-Zen3-APUs.patch"
    "sys-kernel_arch-sources-g14_files-8011-Bluetooth-btusb-Enable-MSFT-extension-for-Mediatek-Chip-MT7921.patch"
    "sys-kernel_arch-sources-g14_files-8012-mt76-mt7915-send-EAPOL-frames-at-lowest-rate.patch"
    "sys-kernel_arch-sources-g14_files-8013-mt76-mt7921-robustify-hardware-initialization-flow.patch"
    "sys-kernel_arch-sources-g14_files-8014-mt76-mt7921-fix-retrying-release-semaphore-without-end.patch"
    "sys-kernel_arch-sources-g14_files-8015-mt76-mt7921-send-EAPOL-frames-at-lowest-rate.patch"
    "sys-kernel_arch-sources-g14_files-8016-mt76-mt7921-Add-mt7922-support.patch"
    "sys-kernel_arch-sources-g14_files-8017-mt76-mt7921-enable-VO-tx-aggregation.patch"
    "sys-kernel_arch-sources-g14_files-8018-mt76-mt7921-fix-dma-hang-in-rmmod.patch"
    "sys-kernel_arch-sources-g14_files-8019-mt76-mt7921-fix-firmware-usage-of-RA-info-using-legacy-rates.patch"
    "sys-kernel_arch-sources-g14_files-8020-mt76-mt7921-Fix-out-of-order-process-by-invalid-even.patch"
    "sys-kernel_arch-sources-g14_files-8021-mt76-mt7921-fix-the-inconsistent-state-between-bind-and-unbind.patch"
    "sys-kernel_arch-sources-g14_files-8022-mt76-mt7921-report-HE-MU-radiotap.patch"
    "sys-kernel_arch-sources-g14_files-8023-v2-mt76-mt7921-fix-kernel-warning-from-cfg80211_calculate_bitrate.patch"
    "sys-kernel_arch-sources-g14_files-8024-mediatek-more-bt-patches.patch"
    "sys-kernel_arch-sources-g14_files-8025-r8169_Add_device_10ec_8162_to_driver.patch"
    "sys-kernel_arch-sources-g14_files-8026-cfg80211-dont-WARN-if-a-self-managed-device.patch"
    "sys-kernel_arch-sources-g14_files-8050-move_bpp_range_decision.patch"
    "sys-kernel_arch-sources-g14_files-8050-r8152-fix-spurious-wakeups-from-s0i3.patch"
    "sys-kernel_arch-sources-g14_files-8051-amdgpu_enable_dsc_over_edp.patch"
    "sys-kernel_arch-sources-g14_files-8052-amdgpu-disable_dsc_edp.patch"
    "sys-kernel_arch-sources-g14_files-9001-v5.14.16-s0ix-patch-2021-11-02.patch"
    "sys-kernel_arch-sources-g14_files-9002-Issue-1710-1712-debugging-and-speculative-fixes.patch"
    "sys-kernel_arch-sources-g14_files-9004-HID-asus-Reduce-object-size-by-consolidating-calls.patch"
    "sys-kernel_arch-sources-g14_files-9005-acpi-battery-Always-read-fresh-battery-state-on-update.patch"
    "sys-kernel_arch-sources-g14_files-9006-amd-c3-entry.patch"
    "sys-kernel_arch-sources-g14_files-9007-squashed-net-tcp_bbr-bbr2-for-5.14.y.patch"
    "sys-kernel_arch-sources-g14_files-9008-fix-cpu-hotplug.patch"
    "sys-kernel_arch-sources-g14_files-9009-amd-pstate-sqashed.patch"
    "sys-kernel_arch-sources-g14_files-9010-ACPI-PM-s2idle-Don-t-report-missing-devices-as-faili.patch"
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
    ++ cachyosPatches
    ++ (lib.optional asus asusPatches);
    postPatch = ''
      install -Dm644 ${kconfigClearence} arch/x86/configs/cachyos_defconfig
    '';
  };
}
