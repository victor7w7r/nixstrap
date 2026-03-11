{
  lib,
  pkgs,
  kernels,
  hardened,
  ...
}:
let
  version = if hardened then kernels.hardened.linux.version else kernels.lts.linux.version;
  majorMinor = lib.versions.majorMinor version;
in
{
  linux = pkgs.fetchurl {
    url = "mirror://kernel/linux/kernel/v${lib.versions.major version}.x/linux-${
      if version == "${majorMinor}.0" then majorMinor else version
    }.tar.xz";
    hash = if hardened then kernels.hardened.linux.hash else kernels.lts.linux.hash;
  };

  kernel-config = pkgs.fetchFromGitHub {
    owner = "CachyOS";
    repo = "linux-cachyos";
    rev = kernels.common.config.rev;
    sha256 = kernels.common.config.hash;
    postFetch = ''
      hold="$(mktemp -d)" && conf="$hold/conf"
      cp "$out/linux-cachyos-${if hardened then "hardened" else "lts"}/config" "$conf"
        sed -i '/^#/d' $conf
        sed -i '/^CONFIG_G*CC_/d' $conf
        sed -i '/^CONFIG_LD_/d' $conf
        sed -i '/^CONFIG_RUSTC*_/d' $conf
        sed -i '/^CONFIG_CC_/d' $conf
        sed -i '/^CONFIG_KUNIT$/d' $conf
        sed -i '/^CONFIG_RUNTIME_TESTING_MENU/d' $conf
        # Remove drivers
        sed -i '/^CONFIG_SND_/d' $conf
        # sed -i '/^CONFIG_NET_/d' $conf
        sed -i '/^CONFIG_.*_FS=/d' $conf
        sed -i '/^CONFIG_MMC_/d' $conf
        sed -i '/^CONFIG_MEMSTICK_/d' $conf
        sed -i '/^CONFIG_SYSTEM/d' $conf
        sed -i '/^CONFIG_MEDIA_/d' $conf
        sed -i '/^CONFIG_SSB/d' $conf
        sed -i '/^CONFIG_IIO/d' $conf
        sed -i '/^CONFIG_USB_/d' $conf
        # sed -i '/^CONFIG_PHY_/d' $conf
        # sed -i '/^CONFIG_DRM_/d' $conf
        # sed -i '/^CONFIG_FB_/d' $conf
        sed -i '/^CONFIG_MFD_/d' $conf
        sed -i '/^CONFIG_GPIO/d' $conf
        sed -i '/^CONFIG_REGULATOR/d' $conf
        sed -i '/^CONFIG_COMEDI/d' $conf
        # sed -i '/^CONFIG_SENSORS/d' $conf
        sed -i '/^CONFIG_BLK_DEV/d' $conf
        sed -i '/^CONFIG_SCSI_/d' $conf
        sed -i '/^CONFIG_DEBUG_/d' $conf
        sed -i '/^CONFIG_.*_PHY=/d' $conf
        sed -i '/^CONFIG_INPUT_/d' $conf
        sed -i '/^CONFIG_JOYSTICK_/d' $conf
        sed -i '/^CONFIG_PTP_1588_CLOCK/d' $conf
        sed -i '/^CONFIG_ATH/d' $conf
        sed -i '/^$/N;/\n$/D' $conf
        rm -rfv "$out" && cp -v "$conf" "$out"
    '';
  };

  cachy-patches = pkgs.fetchFromGitHub {
    owner = "CachyOS";
    repo = "kernel-patches";
    rev = kernels.common.config.patches;
    sha256 = kernels.common.config.hash;
    postFetch = ''
      find "$out" -type f \
        ! -path "*/sched/0001-bore-cachy.patch" \
        ! -path "*/misc/0001-hardened.patch" \
        ! -path "*/misc/0001-acpi-call.patch" \
        ! -path "*/misc/0001-handheld.patch" \
        ! -name "0001-amd-pstate.patch" \
        ! -name "0002-asus.patch" \
        ! -name "0008-intel-pstate.patch" \
        ! -name "0001-cachyos-base-all.patch" \
        ! -name "0009-sched-ext.patch" \
        ! -name "0010-t2.patch" -delete
      find "$out" -type d -empty -delete
    '';
  };

  asus-patches = pkgs.fetchgit {
    url = kernels.lts.asus.url;
    rev = kernels.lts.asus.rev;
    sha256 = kernels.lts.asus.hash;
    postFetch = ''find "$out" -type f ! -name "*.patch" -delete'';
  };
}
