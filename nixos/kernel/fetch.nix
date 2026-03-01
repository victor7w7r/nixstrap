{
  pkgs,
  asusPatchesHash,
  asusPatchesRev,
  kernelConfigHash,
  cachyPatchesHash,
  hardened ? false,
}:
{
  kernel-config = pkgs.fetchFromGitHub {
    owner = "CachyOS";
    repo = "linux-cachyos";
    rev = "master";
    sha256 = kernelConfigHash;
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
    rev = "master";
    sha256 = cachyPatchesHash;
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
    url = "https://gitlab.com/asus-linux/linux-g14";
    rev = asusPatchesRev;
    sha256 = asusPatchesHash;
    postFetch = ''find "$out" -type f ! -name "*.patch" -delete'';
  };
}
