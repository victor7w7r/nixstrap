#!/usr/bin/env bash

get_ssid() {
  case $(uname -s) in
  Linux)
    SSID=$(iw dev | sed -nr 's/^\t\tssid (.*)/\1/p')
    if [ -n "$SSID" ]; then echo "$SSID"; else echo "Ethernet"; fi
    ;;
  Darwin)
    local wifi_network=$(ipconfig getsummary en0 | awk -F ' SSID : ' '/ SSID : / {print $2}')
    local airport=$(networksetup -getairportnetwork en0 | cut -d ':' -f 2)
    if [[ $airport != "You are not associated with an AirPort network." ]]; then
      echo "$airport" | sed 's/^[[:blank:]]*//g'
    elif [[ $wifi_network != "" ]]; then
      echo "$wifi_network" | sed 's/^[[:blank:]]*//g'
    else
      echo "Ethernet"
    fi
    ;;
  CYGWIN* | MINGW32* | MSYS* | MINGW*) ;;
  *) ;;
  esac
}

main() {
  if ping -q -c 1 -W 1 "google.com" &>/dev/null; then
    get_ssid
  else
    echo "Offline"
  fi
}

main
