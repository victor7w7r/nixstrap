{
  pkgs,
  host,
  kernelData,
  hardened,
  majorMinor,
  ...
}:
{
  asus-patches = pkgs.fetchgit {
    url = kernelData.asus.url;
    rev = kernelData.asus.rev;
    sha256 = kernelData.asus.hash;
    postFetch = ''find "$out" -type f ! -name "*.patch" -delete'';
  };

  kernel-config = pkgs.fetchFromGitHub {
    owner = "CachyOS";
    repo = "linux-cachyos";
    rev = kernelData.config.rev;
    sha256 = kernelData.config.hash;
    postFetch = ''
      hold="$(mktemp -d)" && conf="$hold/conf"
      cp "$out/linux-cachyos-${if hardened then "hardened" else "lts"}/config" "$conf"
      ${
        if host != "v7w7r-rc71l" && host != "v7w7r-youyeetoox1" then
          "sed -i '/^CONFIG_IIO/d' $conf"
        else if host != "v7w7r-youyeetoox1" && host != "v7w7r-higole" then
          "sed -i '/^CONFIG_MMC/d' $conf"
        else
          ""
      }
      ${
        if host != "v7w7r-rc71l" then
          "sed -i '/^CONFIG_MFD_/d' $conf && sed -i '/^CONFIG_JOYSTICK_/d' $conf"
        else
          ""
      }
      ${if host == "v7w7r-youyeetoox1" then "sed -i '/^CONFIG_SND_/d' $conf" else ""}
        sed -i '/^#/d' $conf
        sed -i '/^CONFIG_G*CC_/d' $conf
        sed -i '/^CONFIG_ATH/d' $conf
        sed -i '/^CONFIG_LD_/d' $conf
        sed -i '/^CONFIG_RUSTC*_/d' $conf
        sed -i '/^CONFIG_KUNIT$/d' $conf
        sed -i '/^CONFIG_RUNTIME_TESTING_MENU/d' $conf
        sed -i '/^CONFIG_MEMSTICK_/d' $conf
        sed -i '/^CONFIG_SYSTEM/d' $conf
        sed -i '/^CONFIG_MEDIA_/d' $conf
        sed -i '/^CONFIG_SSB/d' $conf
        sed -i '/^CONFIG_COMEDI/d' $conf
        sed -i '/^CONFIG_DEBUG_/d' $conf
        sed -i '/^CONFIG_.*_PHY=/d' $conf
        sed -i '/^CONFIG_PTP_1588_CLOCK/d' $conf
        sed -i '/^$/N;/\n$/D' $conf
        rm -rfv "$out" && cp -v "$conf" "$out"
    '';
  };

  cachy-patches = pkgs.fetchFromGitHub {
    owner = "CachyOS";
    repo = "kernel-patches";
    rev = kernelData.patches.rev;
    sha256 = kernelData.patches.hash;
    postFetch = ''
      PATCHDIR="$out/${majorMinor}"
      BASE="all/0001-cachyos-base-all.patch"

      ${pkgs.patchutils}/bin/filterdiff \
        -x "*/arch/arm/*" -x "*/arch/riscv/*" \
        -x "*/arch/s390/*" -x "*/arch/sparc/*" \
        -x "*/tools/testing/selftests/*" -x "*/drivers/scsi/vhba/*" \
        -x "*/drivers/media/v4l2-core/*" \
        -x "*/drivers/gpu/drm/amd/amdgpu/*" \
        -x "*/drivers/gpu/drm/i915/display/*" \
        -x "*/include/net/tcp.h" \
        ${
          if host != "v7w7r-macmini81" then
            ''-x "*/drivers/soc/apple/*" -x "*/drivers/staging/apple-bce/*"''
          else
            ""
        } \
        ${
          if host != "v7w7r-rc71l" then
            ''-x "*/drivers/gpu/drm/amd/*" -x "*/drivers/hid/hid-asus*" -x "*/drivers/platform/x86/asus*" -x "*/include/linux/hid-asus*"''
          else
            ""
        } \
        "$PATCHDIR/$BASE" > filtered.patch

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
        #chmod +w "$PATCHDIR/$BASE"
        "$PATCHDIR/$BASE" > filtered.patch
        #chmod -w "$PATCHDIR/$BASE"
        rm filtered.patch
    '';
  };
}
