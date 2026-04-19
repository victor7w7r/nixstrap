{
  lib,
  pkgs,
  kernel,
  kernelData,
  ...
}:
let
  majorMinor = lib.versions.majorMinor kernelData.linux-legacy.version;
  fetch = (
    pkgs.callPackage ../fetch.nix {
      inherit kernelData majorMinor;
      isLegacy = true;
    }
  );
  localVer = "-v7w7r-sunxi";
  config = (import ./config.nix);
  modules = ./modules.db;
  sunxiPatch = "${fetch.sunxi}/patches/uwe5622/armbian-sunxi-6.12";

  patches = [
    "${sunxiPatch}/patches.megous/of-property-fw_devlink-Support-allwinner-sram-links.patch"
    "${sunxiPatch}/patches.megous/Fix-broken-allwinner-sram-dependency-on-h616-h618.patch"
    "${sunxiPatch}/patches.drm/drm-sun4i-add-sun50i-h616-hdmi-phy-support.patch"
    "${sunxiPatch}/patches.drm/arm64-dts-allwinner-h616-Add-Mali-GPU-node.patch"
    "${sunxiPatch}/patches.drm/drm-panfrost-add-h616-compatible-string.patch"
    "${sunxiPatch}/patches.armbian/Add-sunxi-addr-driver-Used-to-fix-uwe5622-bluetooth-MAC-address.patch"
    "${sunxiPatch}/patches.armbian/wireless-driver-for-uwe5622-allwinner.patch"
    "${sunxiPatch}/patches.armbian/uwe5622-allwinner-bugfix-v6.3.patch"
    "${sunxiPatch}/patches.armbian/uwe5622-allwinner-v6.3-compilation-fix.patch"
    "${sunxiPatch}/patches.armbian/uwe5622-v6.4-post.patch"
    "${sunxiPatch}/patches.armbian/uwe5622-warnings.patch"
    "${sunxiPatch}/patches.armbian/uwe5622-park-link-v6.1-post.patch"
    "${sunxiPatch}/patches.armbian/uwe5622-v6.1.patch"
    "${sunxiPatch}/patches.armbian/uwe5622-v6.6-fix-tty-sdio.patch"
    "${sunxiPatch}/patches.armbian/uwe5622-fix-setting-mac-address-for-netdev.patch"
    "${sunxiPatch}/patches.armbian/wireless-uwe5622-Fix-compilation-with-6.7-kernel.patch"
    "${sunxiPatch}/patches.armbian/wireless-uwe5622-reduce-system-load.patch"
    "${sunxiPatch}/patches.armbian/uwe5622-v6.11.patch"
    "${sunxiPatch}/patches.armbian/uwe5622-fix-spanning-writes.patch"
    "${sunxiPatch}/patches.armbian/driver-allwinner-h618-emac.patch"
    "${sunxiPatch}/patches.armbian/drivers-pwm-Add-pwm-sunxi-enhance-driver-for-h616.patch"
    "${sunxiPatch}/patches.armbian/arm64-dts-sun50i-h616.dtsi-reserved-memory-512K-for-BL31.patch"
    "${sunxiPatch}/patches.armbian/arm64-dts-sun50i-h616-orangepi-zero2-reg_usb1_vbus-status-ok.patch"
    "${sunxiPatch}/patches.armbian/arm64-dts-sun50i-h616-orangepi-zero2-Enable-GPU-mali.patch"
    "${sunxiPatch}/patches.armbian/arm64-dts-allwinner-sun50i-h616-Add-VPU-node.patch"
    "${sunxiPatch}/patches.armbian/arm64-dts-sun50i-h616-x96-mate-T95-eth-sd-card-hack.patch"
    "${sunxiPatch}/patches.armbian/arm64-dts-sun50i-h616-x96-mate-add-hdmi.patch"
    "${sunxiPatch}/patches.armbian/arm64-dts-add-sun50i-h618-cpu-dvfs.dtsi.patch"
    "${sunxiPatch}/patches.armbian/arm64-dts-allwinner-h616-orangepi-zero2-Enable-expansion-board-.patch"
    "${sunxiPatch}/patches.armbian/arm64-dts-sun50i-h616-bigtreetech-cb1-sd-emmc.patch"
    "${sunxiPatch}/patches.armbian/add-nodes-for-sunxi-info-sunxi-addr-and-sunxi-dump-reg.patch"
    "${sunxiPatch}/patches.armbian/arm64-dts-h616-add-wifi-support-for-orange-pi-zero-2-and-zero3.patch"
    "${sunxiPatch}/patches.armbian/arm64-dts-sun50i-h618-orangepi-zero3-Enable-GPU-mali.patch"
    "${sunxiPatch}/patches.armbian/arm64-dts-h616-add-hdmi-support-for-zero2-and-zero3.patch"
    "${sunxiPatch}/patches.armbian/arm64-sun50i-h616-Add-i2c-2-3-4-uart-2-5-pins.patch"
    "${sunxiPatch}/patches.armbian/arm64-dts-h616-8-Add-overlays-i2c-234-ph-pg-uart-25-ph-pg.patch"
    "${sunxiPatch}/patches.armbian/arm64-dts-sun50i-h618-orangepi-zero2w-Add-missing-nodes.patch"
    "${sunxiPatch}/patches.armbian/add-dtb-overlay-for-zero2w.patch"
    "${sunxiPatch}/patches.armbian/Sound-for-H616-H618-Allwinner-SOCs.patch"
    "${sunxiPatch}/patches.armbian/drv-nvmem-sunxi_sid-Support-SID-on-H616.patch"
    "${sunxiPatch}/patches.armbian/nvmem-sunxi_sid-add-sunxi_get_soc_chipid-sunxi_get_serial.patch"
    "${sunxiPatch}/patches.armbian/ARM64-dts-sun50i-h616-BigTreeTech-CB1-Enable-HDMI.patch"
    "${sunxiPatch}/patches.armbian/ARM64-dts-sun50i-h616-BigTreeTech-CB1-Enable-EMAC1.patch"
    "${sunxiPatch}/patches.armbian/arm64-dts-sun50i-h616-Add-i2c3-pa-pwm-pins.patch"
    "${sunxiPatch}/patches.armbian/arm64-dts-allwinner-Add-axp313a.dtsi.patch"
    "${sunxiPatch}/patches.armbian/arm64-allwinner-Add-sun50i-h618-bananapi-m4-berry-support.patch"
    "${sunxiPatch}/patches.armbian/sun50i-h616-Add-the-missing-digital-audio-nodes.patch"
    "${fetch.patches}/${majorMinor}/0002-bbr3.patch"
    #"${fetch.patches}/${majorMinor}/0003-cachy.patch"
    "${fetch.patches}/${majorMinor}/0007-zstd.patch"
  ];
in

pkgs.stdenv.mkDerivation {
  #inherit patches;
  src = fetch.linux-legacy;
  name = "linux-${majorMinor}${localVer}-config";
  stdenv = pkgs.gcc14Stdenv;
  /*
    .override {
    stdenv = pkgs.ccacheStdenv;
    };
  */

  nativeBuildInputs = kernel.nativeBuildInputs ++ kernel.buildInputs;
  installPhase = "cp .config $out";
  buildPhase = ''
    export ARCH=arm64

    cp "${fetch.sunxi-kconfig}" ".config"

    #export LSMOD=$(mktemp)
    #cat "${modules}" | sort > $LSMOD
    #(yes "" | make LSMOD=$LSMOD localmodconfig) || true

    make $makeFlags ARCH=arm64 olddefconfig
    patchShebangs scripts/config
    scripts/config ${lib.concatStringsSep " " config}
    make $makeFlags ARCH=arm64 olddefconfig
  '';

  meta = pkgs.linuxPackages.kernel.passthru.configfile.meta // {
    platforms = [ "aarch64-linux" ];
  };

  passthru = {
    version = kernelData.linux-legacy.version;
    inherit localVer patches;
  };
}
