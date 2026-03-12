{
  pkgs,
  kernelData,
  hardened,
  majorMinor,
  host,
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
      find "$out" -mindepth 1 -type f \
        ! -path "*/misc/0001-hardened.patch" \
        ! -path "*/misc/0001-handheld.patch" \
        ! -path "*/misc/0001-acpi-call.patch" \
        ! -path "*/misc/nap-governor.patch" \
        ! -path "*/misc/reflex-governor.patch" \
        ! -path "*/sched/0001-bore-cachy.patch" \
        ! -name "0001-amd-pstate.patch" \
        ! -name "0002-asus.patch" \
        ! -name "0003-bbr3.patch" \
        ! -name "0004-cachy.patch" \
        ! -name "0005-crypto.patch" \
        ! -name "0006-fixes.patch" \
        ! -name "0007-hdmi.patch" \
        ! -name "0008-intel-pstate.patch" \
        ! -name "0009-sched-ext.patch" \
        ! -name "0010-t2.patch" -delete
        find "$out" -type d -empty -delete

        ${pkgs.patchutils}/bin/filterdiff -x "*/include/net/tcp.h" \
         "$out/${majorMinor}/0003-bbr3.patch" > bbr3-filter.patch
         cat bbr3-filter.patch > "$out/${majorMinor}/0003-bbr3.patch"
    '';
  };
}
