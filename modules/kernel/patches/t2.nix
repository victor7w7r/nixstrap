{ inputs, ... }:
{
  flake-file.inputs.t2-patches = {
    url = "github:t2linux/linux-t2-patches";
    flake = false;
  };

  kernel.patches.t2 =
    { }:
    map (patch: "${inputs.t2-patches}/${patch}.patch") [
      "1001-Add-t2bce-driver-stack"
      "1002-Integrate-t2bce-driver-stack"
      "2008-i915-4-lane-quirk-for-mbp15-1"
      "2009-apple-gmux-allow-switching-to-igpu-at-probe"
      "3001-applesmc-convert-static-structures-to-drvdata"
      "3002-applesmc-make-io-port-base-addr-dynamic"
      "3003-applesmc-switch-to-acpi_device-from-platform"
      "3004-applesmc-key-interface-wrappers"
      "3005-applesmc-basic-mmio-interface-implementation"
      "3006-applesmc-fan-support-on-T2-Macs"
      "3007-applesmc-Add-iMacPro-to-applesmc_whitelist"
      "3008-applesmc-make-applesmc_remove-void"
      "3009-applesmc-battery-charge-limiter"
      "4001-asahi-trackpad"
      "7001-drm-i915-fbdev-Discard-BIOS-framebuffers-exceeding-h"
      "7002-drm-amdgpu-reset-VI-ASIC-on-MacBookPro15-1"
      "8001-Add-APFS-driver"
      "8002-Necessary-modifications-to-build-APFS-with-the-kerne"
    ];
}
