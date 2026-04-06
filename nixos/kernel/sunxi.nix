{
  lib,
  pkgs,
  kernelData,
  ...
}:
let
  sunxiRepo = "${
    (pkgs.callPackage ./fetch.nix { inherit kernelData; }).sunxi
  }/patches/uwe5622/armbian-sunxi-6.12";

  selectedPatchLines = lib.splitString "\n" (
    builtins.readFile (sunxiRepo + "/selected-for-opi-zero2w.list")
  );

  armRelPaths = lib.filter (line: line != "" && !(lib.hasPrefix "#" line)) (
    map lib.strings.trim selectedPatchLines
  );

  armPatches = map (relPath: { patch = sunxiRepo + "/${relPath}"; }) armRelPaths;
in
{
  packages = pkgs.linuxPackagesFor (
    pkgs.linux.overrideAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.ccache ];
      postPatch = (old.postPatch or "") + ''
        if ! grep -q 'obj-\$(CONFIG_SPARD_WLAN_SUPPORT) += uwe5622/' drivers/net/wireless/Makefile; then
          echo 'obj-$(CONFIG_SPARD_WLAN_SUPPORT) += uwe5622/' >> drivers/net/wireless/Makefile
        fi

        # Armbian's UWE makefile snippets assume /bin/pwd exists.
        # Nix sandboxes don't guarantee that path, so use PATH-resolved pwd.
        if [ -d drivers/net/wireless/uwe5622 ]; then
          grep -rl '/bin/pwd' drivers/net/wireless/uwe5622 \
            | while IFS= read -r file; do
                substituteInPlace "$file" --replace-fail '/bin/pwd' 'pwd'
              done
        fi

        # Linux 6.12 needs OF declarations in tty-sdio for DT parsing helpers.
        tty_sdio_file="drivers/net/wireless/uwe5622/tty-sdio/tty.c"
        if [ -f "$tty_sdio_file" ]; then
          grep -q '^#include <linux/of_device.h>$' "$tty_sdio_file" || sed -i '1i #include <linux/of_device.h>' "$tty_sdio_file"
          grep -q '^#include <linux/of.h>$' "$tty_sdio_file" || sed -i '1i #include <linux/of.h>' "$tty_sdio_file"
        fi

        # Linux 6.12 adds a link_id argument to tdls_mgmt callback.
        cfg80211_file="drivers/net/wireless/uwe5622/unisocwifi/cfg80211.c"
        if [ -f "$cfg80211_file" ]; then
          perl -0pi -e 's/(sprdwl_cfg80211_tdls_mgmt\s*\([^\)]*const\s+u8\s*\*peer,\s*)(u8\s+action_code)/\1int link_id, \2/s' "$cfg80211_file"
          perl -0pi -e 's/strncpy\(\s*scan_ssids->ssid\s*,\s*ssids\[i\]\.ssid\s*,\s*[^\)]*\)/memcpy(scan_ssids->ssid, ssids[i].ssid, ssids[i].ssid_len)/g' "$cfg80211_file"
        fi

        # Linux 6.12.70 netlink API expects split op callback signatures.
        npi_file="drivers/net/wireless/uwe5622/unisocwifi/npi.c"
        if [ -f "$npi_file" ]; then
          perl -0pi -e 's/const\s+struct\s+genl_ops\s*\*\s*(ops)/const struct genl_split_ops *\1/g' "$npi_file"
        fi
      '';
      preConfigure = (old.preConfigure or "") + ''
                export CCACHE_DIR=/nix/var/cache/ccache-kernel
                export CCACHE_COMPRESS=1
                export CCACHE_UMASK=007

                # ccache can break stdin-based compiler probes (`... -x c -`) used by Kbuild.
                # Wrap compilers to bypass ccache for stdin probes while caching normal compiles.
                ccache_wrap() {
                  real_compiler="$1"
                  wrapper_path="$2"
                  cat > "$wrapper_path" <<EOF
        #!/bin/sh
        for arg in "\$@"; do
          if [ "\$arg" = "-" ]; then
            exec "$real_compiler" "\$@"
          fi
        done
        exec ccache "$real_compiler" "\$@"
        EOF
                  chmod +x "$wrapper_path"
                }

                ccache_wrap "${pkgs.stdenv.cc.targetPrefix}cc" "$TMPDIR/cc-with-ccache"
                ccache_wrap cc "$TMPDIR/hostcc-with-ccache"
                ccache_wrap c++ "$TMPDIR/hostcxx-with-ccache"

                makeFlags+=("CC=$TMPDIR/cc-with-ccache")
                makeFlags+=("HOSTCC=$TMPDIR/hostcc-with-ccache")
                makeFlags+=("HOSTCXX=$TMPDIR/hostcxx-with-ccache")
      '';
    })
  );

  patches = armPatches ++ [
    {
      name = "opi-zero-2w-minimal";
      patch = null;
      structuredExtraConfig = with lib.kernel; {
        CRYPTO_ZSTD = yes;
        DRM_LIMA = yes;
        DRM_SUN4I = yes;
        DRM_RADEON = no;

        WLAN_VENDOR_ATH = no;
        WLAN_VENDOR_BROADCOM = yes;
        WLAN_VENDOR_INTEL = no;
        WLAN_VENDOR_MARVELL = no;
        WLAN_VENDOR_TI = no;

        SPARD_WLAN_SUPPORT = yes;
        AW_WIFI_DEVICE_UWE5622 = yes;
        WLAN_UWE5622 = module;
        SPRDWL_NG = module;
        TTY_OVERY_SDIO = module;
        SUNXI_ADDR_MGT = module;

        SOUND = yes;
        SND = yes;
        SND_SOC = yes;
        SND_SUN4I_CODEC = yes;
      };
    }
  ];
}
