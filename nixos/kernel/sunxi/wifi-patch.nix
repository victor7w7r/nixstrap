''
  if ! grep -q 'obj-\$(CONFIG_SPARD_WLAN_SUPPORT) += uwe5622/' drivers/net/wireless/Makefile; then
    echo 'obj-$(CONFIG_SPARD_WLAN_SUPPORT) += uwe5622/' >> drivers/net/wireless/Makefile
  fi

  if [ -d drivers/net/wireless/uwe5622 ]; then
    grep -rl '/bin/pwd' drivers/net/wireless/uwe5622 \
      | while IFS= read -r file; do
          substituteInPlace "$file" --replace-fail '/bin/pwd' 'pwd'
        done
  fi

  tty_sdio_file="drivers/net/wireless/uwe5622/tty-sdio/tty.c"
  if [ -f "$tty_sdio_file" ]; then
    grep -q '^#include <linux/of_device.h>$' "$tty_sdio_file" || sed -i '1i #include <linux/of_device.h>' "$tty_sdio_file"
    grep -q '^#include <linux/of.h>$' "$tty_sdio_file" || sed -i '1i #include <linux/of.h>' "$tty_sdio_file"
  fi

  cfg80211_file="drivers/net/wireless/uwe5622/unisocwifi/cfg80211.c"
  if [ -f "$cfg80211_file" ]; then
    perl -0pi -e 's/(sprdwl_cfg80211_tdls_mgmt\s*\([^\)]*const\s+u8\s*\*peer,\s*)(u8\s+action_code)/\1int link_id, \2/s' "$cfg80211_file"
    perl -0pi -e 's/strncpy\(\s*scan_ssids->ssid\s*,\s*ssids\[i\]\.ssid\s*,\s*[^\)]*\)/memcpy(scan_ssids->ssid, ssids[i].ssid, ssids[i].ssid_len)/g' "$cfg80211_file"
  fi

  npi_file="drivers/net/wireless/uwe5622/unisocwifi/npi.c"
  if [ -f "$npi_file" ]; then
    perl -0pi -e 's/const\s+struct\s+genl_ops\s*\*\s*(ops)/const struct genl_split_ops *\1/g' "$npi_file"
  fi
''
